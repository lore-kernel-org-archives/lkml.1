Return-Path: <linux-kernel-owner+w=401wt.eu-S936874AbXGZUQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936874AbXGZUQl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936604AbXGZUQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:16:00 -0400
Received: from nz-out-0506.google.com ([64.233.162.231]:60810 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936463AbXGZUP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:15:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=QNQ5yO7WySFCklBDi106ntPJEANVS0yYQvpTSLMqPAdEfYb5OXcZpjIiL1GnA5bJhsH94EZYiY21Kz3ecbpE8LZh1WhWsexZQfshOkZI9CidggPLIUM1EXIFbNFDuJH94IR6YwUW9/m92pik06CE1zeVHDHiYa4oL1nAgmIZAtg=
Message-ID: <86802c440707261315r614433beu4fc5ab3b1d8fae94@mail.gmail.com>
Date: Thu, 26 Jul 2007 13:15:57 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>, "Andi Kleen" <ak@suse.de>,
       "Christoph Lameter" <clameter@sgi.com>
Subject: [PATCH 03/05] x86_64: remove never used apic_mapped
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_205836_15898085.1185480957772"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_205836_15898085.1185480957772
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline



------=_Part_205836_15898085.1185480957772
Content-Type: text/x-patch; name=apicid_to_node_3.diff; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4loszer
Content-Disposition: attachment; filename="apicid_to_node_3.diff"

W1BBVENIIDAzLzA1XSB4ODZfNjQ6IHJlbW92ZSBuZXZlciB1c2VkIGFwaWNfbWFwcGVkCgpTaWdu
ZWQtb2ZmLWJ5OiBZaW5naGFpIEx1IDx5aGx1Lmtlcm5lbEBnbWFpbC5jb20+CgpkaWZmIC0tZ2l0
IGEvYXJjaC94ODZfNjQva2VybmVsL2FwaWMuYyBiL2FyY2gveDg2XzY0L2tlcm5lbC9hcGljLmMK
aW5kZXggOTAwZmYzOC4uNzBiOWUyYiAxMDA2NDQKLS0tIGEvYXJjaC94ODZfNjQva2VybmVsL2Fw
aWMuYworKysgYi9hcmNoL3g4Nl82NC9rZXJuZWwvYXBpYy5jCkBAIC0zOSw3ICszOSw2IEBACiAj
aW5jbHVkZSA8YXNtL2hwZXQuaD4KICNpbmNsdWRlIDxhc20vYXBpYy5oPgogCi1pbnQgYXBpY19t
YXBwZWQ7CiBpbnQgYXBpY192ZXJib3NpdHk7CiBpbnQgYXBpY19ydW5zX21haW5fdGltZXI7CiBp
bnQgYXBpY19jYWxpYnJhdGVfcG10bXIgX19pbml0ZGF0YTsKQEAgLTcwNiw4ICs3MjksOCBAQCB2
b2lkIF9faW5pdCBpbml0X2FwaWNfbWFwcGluZ3Modm9pZCkKIAkJYXBpY19waHlzID0gbXBfbGFw
aWNfYWRkcjsKIAogCXNldF9maXhtYXBfbm9jYWNoZShGSVhfQVBJQ19CQVNFLCBhcGljX3BoeXMp
OwotCWFwaWNfbWFwcGVkID0gMTsKLQlhcGljX3ByaW50ayhBUElDX1ZFUkJPU0UsIm1hcHBlZCBB
UElDIHRvICUxNmx4ICglMTZseClcbiIsIEFQSUNfQkFTRSwgYXBpY19waHlzKTsKKwlhcGljX3By
aW50ayhBUElDX1ZFUkJPU0UsICJtYXBwZWQgQVBJQyB0byAlMTZseCAoJTE2bHgpXG4iLAorCQkJ
CUFQSUNfQkFTRSwgYXBpY19waHlzKTsKIAogCS8qIFB1dCBsb2NhbCBBUElDIGludG8gdGhlIHJl
c291cmNlIG1hcC4gKi8KIAlsYXBpY19yZXNvdXJjZS5zdGFydCA9IGFwaWNfcGh5czsKZGlmZiAt
LWdpdCBhL2luY2x1ZGUvYXNtLXg4Nl82NC9hcGljLmggYi9pbmNsdWRlL2FzbS14ODZfNjQvYXBp
Yy5oCmluZGV4IDg1MTI1ZWYuLmI5MzE1ZjggMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvYXNtLXg4Nl82
NC9hcGljLmgKKysrIGIvaW5jbHVkZS9hc20teDg2XzY0L2FwaWMuaApAQCAtMTksNyArMTksNiBA
QAogZXh0ZXJuIGludCBhcGljX3ZlcmJvc2l0eTsKIGV4dGVybiBpbnQgYXBpY19ydW5zX21haW5f
dGltZXI7CiBleHRlcm4gaW50IGlvYXBpY19mb3JjZTsKLWV4dGVybiBpbnQgYXBpY19tYXBwZWQ7
CiAKIC8qCiAgKiBEZWZpbmUgdGhlIGRlZmF1bHQgbGV2ZWwgb2Ygb3V0cHV0IHRvIGJlIHZlcnkg
bGl0dGxlCg==
------=_Part_205836_15898085.1185480957772--
