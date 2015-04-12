
call vital#of("vital").unload()
let s:Keymapping = vital#of("vital").import("Palette.Keymapping")


function! s:test_escape_special_key()
	let Keymapping = s:Keymapping

	OwlCheck Keymapping.escape_special_key("<C-r") is# "<C-r"
	OwlCheck Keymapping.escape_special_key("<C->") is# "<C->"
	OwlCheck Keymapping.escape_special_key("<C-r>") is# "\<C-r>"
	OwlCheck Keymapping.escape_special_key("<Down>") is# "\<Down>"
	OwlCheck Keymapping.escape_special_key("<A-c>") is# "\<A-c>"
	OwlCheck Keymapping.escape_special_key("<A-c><A>D>") is# "\<A-c><A>D>"
	OwlCheck Keymapping.escape_special_key("<^?>") is# "\<C-?>"
endfunction


function! s:test_parse()
	let Keymapping = s:Keymapping

	OwlCheck Keymapping.parse_lhs("!  ñ             aa") is# "ñ"
	OwlCheck Keymapping.parse_lhs("x  <C-A>       * <C-C>ggVG") is# "<C-A>"
	OwlCheck Keymapping.parse_lhs("n  <Space><Space><CR> * :SecretEdit<CR>") is# "<Space><Space><CR>"
	OwlCheck Keymapping.parse_lhs("x  <C-A>       * <C-C>ggVG", "x") is# "<C-A>"
	OwlCheck Keymapping.parse_lhs("x  <C-A>       * <C-C>ggVG", "n") is# ""
	OwlCheck Keymapping.parse_lhs("x  S             <Plug>VSurround") is# "S"
	OwlCheck Keymapping.parse_lhs("x  S             <Plug>VSurround") is# "S"
	OwlCheck Keymapping.parse_lhs("x  S <Plug>VSurround", "x") is# "S"
	OwlCheck Keymapping.parse_lhs("n  S <Plug>VSurround", "x") is# ""
	echom "aa:" . Keymapping.parse_lhs("nox\\  <Plug>(easymotion-prefix)", '\\')
	OwlCheck Keymapping.parse_lhs("nos<Plug>(easymotion-B) * :<C-U>call EasyMotion#WBW(0,1)<CR>") is '<Plug>(easymotion-B)'

	OwlCheck Keymapping.parse_lhs("!  S <Plug>VSurround", "c") is# "S"
	OwlCheck Keymapping.parse_lhs("!  S <Plug>VSurround", "i") is# "S"
	OwlCheck Keymapping.parse_lhs("!  S <Plug>VSurround", "!") is# "S"

	OwlCheck Keymapping.parse_lhs("c  S <Plug>VSurround", "c") is# "S"
	OwlCheck Keymapping.parse_lhs("c  S <Plug>VSurround", "i") is# "S"
	OwlCheck Keymapping.parse_lhs("c  S <Plug>VSurround", "!") is# "S"

	OwlCheck Keymapping.parse_lhs("i  S <Plug>VSurround", "c") is# "S"
	OwlCheck Keymapping.parse_lhs("i  S <Plug>VSurround", "i") is# "S"
	OwlCheck Keymapping.parse_lhs("i  S <Plug>VSurround", "!") is# "S"

	OwlCheck Keymapping.parse_lhs("n  S <Plug>VSurround", "c") is# ""
	OwlCheck Keymapping.parse_lhs("n  S <Plug>VSurround", "i") is# ""
	OwlCheck Keymapping.parse_lhs("n  S <Plug>VSurround", "!") is# ""
endfunction


function! s:test_keymapping()
	let Keymapping = s:Keymapping

	cnoremap <Plug>(vital-palette-keymapping-test) vital-palette-keymapping-test

	OwlCheck index(Keymapping.lhs_key_list("c"), "\<Plug>(vital-palette-keymapping-test)") != -1
	OwlCheck index(Keymapping.rhs_key_list("c"), "vital-palette-keymapping-test") != -1
	echo len(filter(Keymapping.rhs_key_list(), "v:val == ''"))
	OwlCheck len(filter(Keymapping.rhs_key_list(), "v:val == ''")) == 0

	cunmap <Plug>(vital-palette-keymapping-test)
endfunction


