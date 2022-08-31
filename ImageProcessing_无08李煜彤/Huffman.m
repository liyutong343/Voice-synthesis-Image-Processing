function huff = Huffman(Category)

load JpegCoeff.mat DCTAB;
huff = DCTAB(Category+1,2:DCTAB(Category+1,1)+1);
    
end

