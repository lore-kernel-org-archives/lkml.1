Return-Path: <linux-kernel-owner+w=401wt.eu-S1756699AbZAIFxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699AbZAIFxH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:53:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752735AbZAIFwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:52:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.238]:39890 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbZAIFwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:52:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :x-google-sender-auth;
        b=SyxpbDUOu8XAM020BpKuC57UO4vtkO+WELTuGca9z7Zbu4hPUTmu3/LcsTI530ygV5
         I7PpwNavNX8KpA9qUvZOxNnT8LtVcrKs+Qw2NtXK7z+3OsoR8MPmlVCBz9POsIdiaVmD
         oLIPRk06GS4HOmj3QsqToOAEfZbdsSrpvzhbA=
Message-ID: <177c2b150901082152g13515bf2q9575523e28a17f92@mail.gmail.com>
Date: Fri, 9 Jan 2009 01:52:53 -0400
From: "Mhayk Whandson" <eu@mhayk.com.br>
To: linux-kernel@vger.kernel.org, greg@kroah.com, kuba@mareimbrium.org,
       bryder@sgi.com
Subject: [PATCH] ftdi_sio driver support of bar code scanner from Diebold
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_245574_22856963.1231480373550"
X-Google-Sender-Auth: 39b34bab3cbb5152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_245574_22856963.1231480373550
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Added the product id of bcs(bar code scanner) from Diebold Procomp Brazil.

best regards,

-- 
Mhayk Whandson
Linux User #413723
E-mail: eu@mhayk.com.br

------=_Part_245574_22856963.1231480373550
Content-Type: text/x-patch; name=ftdi.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fpqfjjks0
Content-Disposition: attachment; filename=ftdi.patch

ZGlmZiAtdSAuLi8uLi8uLi8uLi9saW51eC0yLjYuMjhiL2xpbnV4LTIuNi4yOC9kcml2ZXJzL3Vz
Yi9zZXJpYWwvZnRkaV9zaW8uYyAuL2Z0ZGlfc2lvLmMKLS0tIC4uLy4uLy4uLy4uL2xpbnV4LTIu
Ni4yOGIvbGludXgtMi42LjI4L2RyaXZlcnMvdXNiL3NlcmlhbC9mdGRpX3Npby5jCTIwMDgtMTIt
MjQgMTk6MjY6MzcuMDAwMDAwMDAwIC0wNDAwCisrKyAuL2Z0ZGlfc2lvLmMJMjAwOS0wMS0wOSAw
MDoxNzo1MC4wMDAwMDAwMDAgLTA0MDAKQEAgLTY2MCw2ICs2NjAsNyBAQAogCXsgVVNCX0RFVklD
RShQQVBPVUNIX1ZJRCwgUEFQT1VDSF9RVUlETzR4NF9QSUQpIH0sCiAJeyBVU0JfREVWSUNFKEZU
RElfVklELCBGVERJX0RPTUlOVEVMTF9ER1FHX1BJRCkgfSwKIAl7IFVTQl9ERVZJQ0UoRlRESV9W
SUQsIEZURElfRE9NSU5URUxMX0RVU0JfUElEKSB9LAorCXsgVVNCX0RFVklDRShGVERJX1ZJRCwg
RElFQk9MRF9CQ1NfU0U5MjNfUElEKSB9LAogCXsgfSwJCQkJCS8qIE9wdGlvbmFsIHBhcmFtZXRl
ciBlbnRyeSAqLwogCXsgfQkJCQkJLyogVGVybWluYXRpbmcgZW50cnkgKi8KIH07CmRpZmYgLXUg
Li4vLi4vLi4vLi4vbGludXgtMi42LjI4Yi9saW51eC0yLjYuMjgvZHJpdmVycy91c2Ivc2VyaWFs
L2Z0ZGlfc2lvLmggLi9mdGRpX3Npby5oCi0tLSAuLi8uLi8uLi8uLi9saW51eC0yLjYuMjhiL2xp
bnV4LTIuNi4yOC9kcml2ZXJzL3VzYi9zZXJpYWwvZnRkaV9zaW8uaAkyMDA4LTEyLTI0IDE5OjI2
OjM3LjAwMDAwMDAwMCAtMDQwMAorKysgLi9mdGRpX3Npby5oCTIwMDktMDEtMDkgMDA6MjM6MjQu
MDAwMDAwMDAwIC0wNDAwCkBAIC0yMCw2ICsyMCw5IEBACiAgKiBQaGlsaXBwIEfDvGhyaW5nIC0g
cGdAZnV0dXJld2FyZS5hdCAtIGFkZGVkIHRoZSBEZXZpY2UgSUQgb2YgdGhlIFVTQiByZWxhaXMK
ICAqIGZyb20gUnVkb2xmIEd1Z2xlcgogICoKKyAqIE1oYXlrIFdoYW5kc29uIC0gZXVAbWhheWsu
Y29tLmJyIC0gYWRkZWQgdGhlIFByb2R1Y3QgSUQgb2YgdGhlIFVTQiBCYXIgQ29kZQorICogU2Nh
bm5lciBmcm9tIERpZWJvbGQgUHJvY29tcCBCcmF6aWwuCisgKgogICovCiAKICNkZWZpbmUgRlRE
SV9WSUQJMHgwNDAzCS8qIFZlbmRvciBJZCAqLwpAQCAtODgxLDYgKzg4NCwxMSBAQAogI2RlZmlu
ZSBSQVRPQ19QUk9EVUNUX0lEX1VTQjYwRgkweGIwMjAKIAogLyoKKyAqIERJRUJPTEQgQkNTIFNF
OTIzCisgKi8KKyNkZWZpbmUgRElFQk9MRF9CQ1NfU0U5MjNfUElEIDB4ZmI5OQorCisvKgogICog
ICBCbVJlcXVlc3RUeXBlOiAgMTEwMCAwMDAwYgogICogICBiUmVxdWVzdDogICAgICAgRlRESV9F
Ml9SRUFECiAgKiAgIHdWYWx1ZTogICAgICAgICAwCgpTaWduZWQtb2ZmLWJ5OiBNaGF5ayBXaGFu
ZHNvbiA8ZXVAbWhheWsuY29tLmJyPgo=
------=_Part_245574_22856963.1231480373550--
