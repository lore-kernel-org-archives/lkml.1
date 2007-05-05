Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbXEEQYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbXEEQYL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933251AbXEEQYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:24:10 -0400
Received: from postfix2-g20.free.fr ([212.27.60.43]:38800 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933313AbXEEQYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:24:09 -0400
Message-ID: <463C7C4C.60208@free.fr>
Date: Sat, 05 May 2007 14:45:00 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070217 Iceape/1.1.1 (Debian-1.1.1-2)
MIME-Version: 1.0
To: Linux and Kernel Video <video4linux-list@redhat.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: PATCH : tuner-simple.c add suport for SECAM-BG with FI1216MF
Content-Type: multipart/mixed;
 boundary="------------080703020302030703020304"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080703020302030703020304
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

this patch allow to use SECAM-BG with the FI1216MF tuner.


Matthieu


--------------080703020302030703020304
Content-Type: text/plain;
 name="FI1216MF_secam_bg"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="FI1216MF_secam_bg"

YWxsb3cgdG8gdXNlIFNFQ0FNLUJHIHdpdGggdGhlIEZJMTIxNk1GIHR1bmVyLgoKVGhlIHNl
bGVjdGlvbiBpcyBkb25lIHdpdGggdGhlIHNlY2FtPUIgbW9kdWxlIGFyZ3VtZW50LgpUaGUg
ZGVmYXVsdCBiZWhhdmlvdXIgc2hvdWxkIGJlIHRoZSBzYW1lIGFzIGJlZm9yZS4KClNpZ25l
ZC1vZmYtYnk6IE1hdHRoaWV1IENBU1RFVCA8Y2FzdGV0Lm1hdHRoaWV1QGZyZWUuZnI+Cklu
ZGV4OiBsaW51eC0yLjYuMjEvZHJpdmVycy9tZWRpYS92aWRlby90dW5lci1zaW1wbGUuYwo9
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjEub3JpZy9kcml2ZXJzL21lZGlhL3ZpZGVv
L3R1bmVyLXNpbXBsZS5jCTIwMDctMDUtMDUgMTQ6MjE6NTYuMDAwMDAwMDAwICswMjAwCisr
KyBsaW51eC0yLjYuMjEvZHJpdmVycy9tZWRpYS92aWRlby90dW5lci1zaW1wbGUuYwkyMDA3
LTA1LTA1IDE0OjMzOjU4LjAwMDAwMDAwMCArMDIwMApAQCAtMjA1LDkgKzIwNSwxMyBAQAog
CQkvKiAweDAxIC0+ID8/PyBubyBjaGFuZ2UgPz8/ICovCiAJCS8qIDB4MDIgLT4gUEFMIEJE
R0hJIC8gU0VDQU0gTCAqLwogCQkvKiAweDA0IC0+ID8/PyBQQUwgb3RoZXJzIC8gU0VDQU0g
b3RoZXJzID8/PyAqLwotCQljYiAmPSB+MHgwMjsKLQkJaWYgKHQtPnN0ZCAmIFY0TDJfU1RE
X1NFQ0FNKQotCQkJY2IgfD0gMHgwMjsKKwkJY2IgJj0gfjB4MDM7CisJCWlmICh0LT5zdGQg
JiBWNEwyX1NURF9TRUNBTV9MKSAvL2Fsc28gdmFsaWQgZm9yIFY0TDJfU1REX1NFQ0FNIAor
CQkJY2IgfD0gUEhJTElQU19NRl9TRVRfUEFMX0w7CisJCWVsc2UgaWYgKHQtPnN0ZCAmIFY0
TDJfU1REX1NFQ0FNX0xDKSAKKwkJCWNiIHw9IFBISUxJUFNfTUZfU0VUX1BBTF9MMjsKKwkJ
ZWxzZSAvKiBWNEwyX1NURF9CfFY0TDJfU1REX0dIICovCisJCQljYiB8PSBQSElMSVBTX01G
X1NFVF9CRzsKIAkJYnJlYWs7CiAKIAljYXNlIFRVTkVSX1RFTUlDXzQwNDZGTTU6Cg==
--------------080703020302030703020304--
