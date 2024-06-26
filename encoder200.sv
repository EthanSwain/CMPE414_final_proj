module encoder200#(parameter WINSIZE = 200)(
    input logic [WINSIZE-1:0] in,
    
    output logic [$clog2(WINSIZE)-1:0] out

);

always_comb begin
    case(1'b1)
in[0]: begin out = 'd0; end
in[1]: begin out = 'd1; end
in[2]: begin out = 'd2; end
in[3]: begin out = 'd3; end
in[4]: begin out = 'd4; end
in[5]: begin out = 'd5; end
in[6]: begin out = 'd6; end
in[7]: begin out = 'd7; end
in[8]: begin out = 'd8; end
in[9]: begin out = 'd9; end
in[10]: begin out = 'd10; end
in[11]: begin out = 'd11; end
in[12]: begin out = 'd12; end
in[13]: begin out = 'd13; end
in[14]: begin out = 'd14; end
in[15]: begin out = 'd15; end
in[16]: begin out = 'd16; end
in[17]: begin out = 'd17; end
in[18]: begin out = 'd18; end
in[19]: begin out = 'd19; end
in[20]: begin out = 'd20; end
in[21]: begin out = 'd21; end
in[22]: begin out = 'd22; end
in[23]: begin out = 'd23; end
in[24]: begin out = 'd24; end
in[25]: begin out = 'd25; end
in[26]: begin out = 'd26; end
in[27]: begin out = 'd27; end
in[28]: begin out = 'd28; end
in[29]: begin out = 'd29; end
in[30]: begin out = 'd30; end
in[31]: begin out = 'd31; end
in[32]: begin out = 'd32; end
in[33]: begin out = 'd33; end
in[34]: begin out = 'd34; end
in[35]: begin out = 'd35; end
in[36]: begin out = 'd36; end
in[37]: begin out = 'd37; end
in[38]: begin out = 'd38; end
in[39]: begin out = 'd39; end
in[40]: begin out = 'd40; end
in[41]: begin out = 'd41; end
in[42]: begin out = 'd42; end
in[43]: begin out = 'd43; end
in[44]: begin out = 'd44; end
in[45]: begin out = 'd45; end
in[46]: begin out = 'd46; end
in[47]: begin out = 'd47; end
in[48]: begin out = 'd48; end
in[49]: begin out = 'd49; end
in[50]: begin out = 'd50; end
in[51]: begin out = 'd51; end
in[52]: begin out = 'd52; end
in[53]: begin out = 'd53; end
in[54]: begin out = 'd54; end
in[55]: begin out = 'd55; end
in[56]: begin out = 'd56; end
in[57]: begin out = 'd57; end
in[58]: begin out = 'd58; end
in[59]: begin out = 'd59; end
in[60]: begin out = 'd60; end
in[61]: begin out = 'd61; end
in[62]: begin out = 'd62; end
in[63]: begin out = 'd63; end
in[64]: begin out = 'd64; end
in[65]: begin out = 'd65; end
in[66]: begin out = 'd66; end
in[67]: begin out = 'd67; end
in[68]: begin out = 'd68; end
in[69]: begin out = 'd69; end
in[70]: begin out = 'd70; end
in[71]: begin out = 'd71; end
in[72]: begin out = 'd72; end
in[73]: begin out = 'd73; end
in[74]: begin out = 'd74; end
in[75]: begin out = 'd75; end
in[76]: begin out = 'd76; end
in[77]: begin out = 'd77; end
in[78]: begin out = 'd78; end
in[79]: begin out = 'd79; end
in[80]: begin out = 'd80; end
in[81]: begin out = 'd81; end
in[82]: begin out = 'd82; end
in[83]: begin out = 'd83; end
in[84]: begin out = 'd84; end
in[85]: begin out = 'd85; end
in[86]: begin out = 'd86; end
in[87]: begin out = 'd87; end
in[88]: begin out = 'd88; end
in[89]: begin out = 'd89; end
in[90]: begin out = 'd90; end
in[91]: begin out = 'd91; end
in[92]: begin out = 'd92; end
in[93]: begin out = 'd93; end
in[94]: begin out = 'd94; end
in[95]: begin out = 'd95; end
in[96]: begin out = 'd96; end
in[97]: begin out = 'd97; end
in[98]: begin out = 'd98; end
in[99]: begin out = 'd99; end
in[100]: begin out = 'd100; end
in[101]: begin out = 'd101; end
in[102]: begin out = 'd102; end
in[103]: begin out = 'd103; end
in[104]: begin out = 'd104; end
in[105]: begin out = 'd105; end
in[106]: begin out = 'd106; end
in[107]: begin out = 'd107; end
in[108]: begin out = 'd108; end
in[109]: begin out = 'd109; end
in[110]: begin out = 'd110; end
in[111]: begin out = 'd111; end
in[112]: begin out = 'd112; end
in[113]: begin out = 'd113; end
in[114]: begin out = 'd114; end
in[115]: begin out = 'd115; end
in[116]: begin out = 'd116; end
in[117]: begin out = 'd117; end
in[118]: begin out = 'd118; end
in[119]: begin out = 'd119; end
in[120]: begin out = 'd120; end
in[121]: begin out = 'd121; end
in[122]: begin out = 'd122; end
in[123]: begin out = 'd123; end
in[124]: begin out = 'd124; end
in[125]: begin out = 'd125; end
in[126]: begin out = 'd126; end
in[127]: begin out = 'd127; end
in[128]: begin out = 'd128; end
in[129]: begin out = 'd129; end
in[130]: begin out = 'd130; end
in[131]: begin out = 'd131; end
in[132]: begin out = 'd132; end
in[133]: begin out = 'd133; end
in[134]: begin out = 'd134; end
in[135]: begin out = 'd135; end
in[136]: begin out = 'd136; end
in[137]: begin out = 'd137; end
in[138]: begin out = 'd138; end
in[139]: begin out = 'd139; end
in[140]: begin out = 'd140; end
in[141]: begin out = 'd141; end
in[142]: begin out = 'd142; end
in[143]: begin out = 'd143; end
in[144]: begin out = 'd144; end
in[145]: begin out = 'd145; end
in[146]: begin out = 'd146; end
in[147]: begin out = 'd147; end
in[148]: begin out = 'd148; end
in[149]: begin out = 'd149; end
in[150]: begin out = 'd150; end
in[151]: begin out = 'd151; end
in[152]: begin out = 'd152; end
in[153]: begin out = 'd153; end
in[154]: begin out = 'd154; end
in[155]: begin out = 'd155; end
in[156]: begin out = 'd156; end
in[157]: begin out = 'd157; end
in[158]: begin out = 'd158; end
in[159]: begin out = 'd159; end
in[160]: begin out = 'd160; end
in[161]: begin out = 'd161; end
in[162]: begin out = 'd162; end
in[163]: begin out = 'd163; end
in[164]: begin out = 'd164; end
in[165]: begin out = 'd165; end
in[166]: begin out = 'd166; end
in[167]: begin out = 'd167; end
in[168]: begin out = 'd168; end
in[169]: begin out = 'd169; end
in[170]: begin out = 'd170; end
in[171]: begin out = 'd171; end
in[172]: begin out = 'd172; end
in[173]: begin out = 'd173; end
in[174]: begin out = 'd174; end
in[175]: begin out = 'd175; end
in[176]: begin out = 'd176; end
in[177]: begin out = 'd177; end
in[178]: begin out = 'd178; end
in[179]: begin out = 'd179; end
in[180]: begin out = 'd180; end
in[181]: begin out = 'd181; end
in[182]: begin out = 'd182; end
in[183]: begin out = 'd183; end
in[184]: begin out = 'd184; end
in[185]: begin out = 'd185; end
in[186]: begin out = 'd186; end
in[187]: begin out = 'd187; end
in[188]: begin out = 'd188; end
in[189]: begin out = 'd189; end
in[190]: begin out = 'd190; end
in[191]: begin out = 'd191; end
in[192]: begin out = 'd192; end
in[193]: begin out = 'd193; end
in[194]: begin out = 'd194; end
in[195]: begin out = 'd195; end
in[196]: begin out = 'd196; end
in[197]: begin out = 'd197; end
in[198]: begin out = 'd198; end
in[199]: begin out = 'd199; end
default: begin
    out = 'd0;
end
    endcase

end

endmodule