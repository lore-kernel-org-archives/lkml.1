Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbXFZJES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbXFZJES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 05:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbXFZJEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 05:04:09 -0400
Received: from web63512.mail.re1.yahoo.com ([69.147.97.67]:37619 "HELO
	web63512.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751783AbXFZJEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 05:04:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=emyPfewM+/m4p0lecPeSp2DnX7Up1aD4qb/veaZYkzdIvun5C/MdYllWgRmdTgvzHOFl6qh8y68q0kVTMueuIt/WUN8NNWxqqQ6blxVrZ4dJjUlby9exlHJSPU/4mTd6TaLblPc6Z4tREBKE4e4kbTr5tAS3hgA4bTmHH1VvFok=;
X-YMail-OSG: aRA4M7cVM1kfSNPiVycbDoj2HJbqdLx0hObpnl5BBtvYlm3epEc0QT848ci7DzQMVfYzjoPEbPeKpePWy3j1JM_pN7F.u.DxOhQ70LCVai1fWfe52kIl_NIr7rmkkg--
Date: Tue, 26 Jun 2007 02:04:06 -0700 (PDT)
From: Ioannis Barkas <risc4all@yahoo.com>
Subject: [PATCH] amd.c: Corrected broken URL and display the same units at all messages
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-371833796-1182848646=:25673"
Content-Transfer-Encoding: 8bit
Message-ID: <891163.25673.qm@web63512.mail.re1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--0-371833796-1182848646=:25673
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Content-Id: 
Content-Disposition: inline

Fixes two messages displaying Megabit (Mb) instead of
Megabyte (MB) and updates URLs.


Hello we are Ioannis Barkas (risc4all@yahoo.com) and
Nikos Barkas (doubl3nuts@yahoo.com).

The printed messages behaviour is not consistent as
one message is printed
with MB and the next two are printed with Mb.Also a
link is broken.

We sent the patch from diff -u as an attachment
because damn yahoo...can't even format an inline patch!


       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers - Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433
--0-371833796-1182848646=:25673
Content-Type: application/octet-stream; name="diff2.log"
Content-Transfer-Encoding: base64
Content-Description: 1728711821-diff2.log
Content-Disposition: attachment; filename="diff2.log"

LS0tIC9saW51eC0yLjYuMjEvYXJjaC9pMzg2L2tlcm5lbC9jcHUvYW1kLmMJ
MjAwNy0wNC0yNiAwNDowODozMi4wMDAwMDAwMDAgLTA0MDAKKysrIC9saW51
eC9hcmNoL2kzODYva2VybmVsL2NwdS9hbWQuYwkyMDA3LTA2LTI2IDExOjE4
OjI1LjAwMDAwMDAwMCAtMDQwMApAQCAtOSwxMCArOSwxMiBAQAogLyoKICAq
CUIgc3RlcCBBTUQgSzYgYmVmb3JlIEIgOTczMHh4eHggaGF2ZSBoYXJkd2Fy
ZSBidWdzIHRoYXQgY2FuIGNhdXNlCiAgKgltaXNleGVjdXRpb24gb2YgY29k
ZSB1bmRlciBMaW51eC4gT3duZXJzIG9mIHN1Y2ggcHJvY2Vzc29ycyBzaG91
bGQKLSAqCWNvbnRhY3QgQU1EIGZvciBwcmVjaXNlIGRldGFpbHMgYW5kIGEg
Q1BVIHN3YXAuCisgKgljb250YWN0IEFNRCBmb3IgcHJlY2lzZSBkZXRhaWxz
IGFuZCBhIENQVSBzd2FwLiBNb3JlIGluZm9ybWF0aW9uIGNhbgorICoJYmUg
Zm91bmQgYXQgZXJyYXR1bSAyLjYuMiBvZiAyMTI2Ni5wZGYuCiAgKgogICoJ
U2VlCWh0dHA6Ly93d3cubXVsdGltYW5pYS5jb20vcG91bG90L2s2YnVnLmh0
bWwKLSAqCQlodHRwOi8vd3d3LmFtZC5jb20vSzYvazZkb2NzL3JldmdkLmh0
bWwKKyAqCQlodHRwOi8vd3d3LmFtZC5jb20vdXMtZW4vUHJvY2Vzc29ycy9U
ZWNobmljYWxSZXNvdXJjZXMvMCwsMzBfMTgyXzczOV8xMTAyLDAwLmh0bWwK
KyAqCQlodHRwOi8vd3d3LmFtZC5jb20vdXMtZW4vYXNzZXRzL2NvbnRlbnRf
dHlwZS93aGl0ZV9wYXBlcnNfYW5kX3RlY2hfZG9jcy8yMTI2Ni5wZGYKICAq
CiAgKglUaGUgZm9sbG93aW5nIHRlc3QgaXMgZXJtLi4gaW50ZXJlc3Rpbmcu
IEFNRCBuZWdsZWN0ZWQgdG8gdXAKICAqCXRoZSBjaGlwIHNldHRpbmcgd2hl
biBmaXhpbmcgdGhlIGJ1ZyBidXQgdGhleSBhbHNvIHR3ZWFrZWQgc29tZQpA
QCAtMTQ2LDcgKzE0OCw3IEBACiAJCQkvKiBLNiB3aXRoIG9sZCBzdHlsZSBX
SENSICovCiAJCQlpZiAoYy0+eDg2X21vZGVsIDwgOCB8fAogCQkJICAgKGMt
Png4Nl9tb2RlbD09IDggJiYgYy0+eDg2X21hc2sgPCA4KSkgewotCQkJCS8q
IFdlIGNhbiBvbmx5IHdyaXRlIGFsbG9jYXRlIG9uIHRoZSBsb3cgNTA4TWIg
Ki8KKwkJCQkvKiBXZSBjYW4gb25seSB3cml0ZSBhbGxvY2F0ZSBvbiB0aGUg
bG93IDUwOE1CICovCiAJCQkJaWYobWJ5dGVzPjUwOCkKIAkJCQkJbWJ5dGVz
PTUwODsKIApAQCAtMTU4LDcgKzE2MCw3IEBACiAJCQkJCXdiaW52ZCgpOwog
CQkJCQl3cm1zcihNU1JfSzZfV0hDUiwgbCwgaCk7CiAJCQkJCWxvY2FsX2ly
cV9yZXN0b3JlKGZsYWdzKTsKLQkJCQkJcHJpbnRrKEtFUk5fSU5GTyAiRW5h
Ymxpbmcgb2xkIHN0eWxlIEs2IHdyaXRlIGFsbG9jYXRpb24gZm9yICVkIE1i
XG4iLAorCQkJCQlwcmludGsoS0VSTl9JTkZPICJFbmFibGluZyBvbGQgc3R5
bGUgSzYgd3JpdGUgYWxsb2NhdGlvbiBmb3IgJWQgTUJcbiIsCiAJCQkJCQlt
Ynl0ZXMpOwogCQkJCX0KIAkJCQlicmVhazsKQEAgLTE3OSw3ICsxODEsNyBA
QAogCQkJCQl3YmludmQoKTsKIAkJCQkJd3Jtc3IoTVNSX0s2X1dIQ1IsIGws
IGgpOwogCQkJCQlsb2NhbF9pcnFfcmVzdG9yZShmbGFncyk7Ci0JCQkJCXBy
aW50ayhLRVJOX0lORk8gIkVuYWJsaW5nIG5ldyBzdHlsZSBLNiB3cml0ZSBh
bGxvY2F0aW9uIGZvciAlZCBNYlxuIiwKKwkJCQkJcHJpbnRrKEtFUk5fSU5G
TyAiRW5hYmxpbmcgbmV3IHN0eWxlIEs2IHdyaXRlIGFsbG9jYXRpb24gZm9y
ICVkIE1CXG4iLAogCQkJCQkJbWJ5dGVzKTsKIAkJCQl9CiAK

--0-371833796-1182848646=:25673--
