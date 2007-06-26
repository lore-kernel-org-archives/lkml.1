Return-Path: <linux-kernel-owner+w=401wt.eu-S1757408AbXFZMez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408AbXFZMez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbXFZMeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:34:46 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:2676 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753214AbXFZMep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=aW32f+f1bv6Zy4Uncn+bUFcgApCcXlV2Bb6C2cZ/Ky78xHS4wzWmrjzVhQ43Gaab/fvjAOtS0CPR+3xc0yw3nTQdzAStLrw0/F4eNwt5aaRrp0hI+T1UbtFpNW+Qq7DBUyyQZAIMzoRAvpQVKlS7pc7wm5pSXpZBi74mwApX+cw=
Message-ID: <5d5443650706260534k5d6aca34k9f574b6ffddf85b2@mail.gmail.com>
Date: Tue, 26 Jun 2007 18:04:44 +0530
From: "Trilok Soni" <soni.trilok@gmail.com>
To: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       akpm@linux-foundation.org
Subject: [PATCH 02/17] OMAP: Add TI OMAP1610 accelerator entry.
Cc: "Tony Lindgren" <tony@atomide.com>, imre.deak@solidboot.com,
       juha.yrjola@solidboot.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_17296_8578684.1182861284949"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_17296_8578684.1182861284949
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
--Trilok Soni

------=_Part_17296_8578684.1182861284949
Content-Type: text/x-patch; 
	name=0002-OMAP-Add-TI-OMAP1610-accelerator-entry.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f3ed1yvw
Content-Disposition: attachment; filename="0002-OMAP-Add-TI-OMAP1610-accelerator-entry.patch"

RnJvbSAxZjlkNTg2MmU0ZDRkMDc4ZjM4YTNhMDMzYjczOTQ1N2YyNGVmOTg2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBJbXJlIERlYWsgPGltcmUuZGVha0Bzb2xpZGJvb3QuY29tPgpE
YXRlOiBTYXQsIDI2IE1heSAyMDA3IDE5OjE5OjE5ICswNTMwClN1YmplY3Q6IFtQQVRDSCAwMi8x
N10gT01BUDogQWRkIFRJIE9NQVAxNjEwIGFjY2VsZXJhdG9yIGVudHJ5LgoKU2lnbmVkLW9mZi1i
eTogVHJpbG9rIFNvbmkgPHNvbmkudHJpbG9rQGdtYWlsLmNvbT4KLS0tCiBpbmNsdWRlL2xpbnV4
L2ZiLmggfCAgICAxICsKIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25zKCspLCAwIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZmIuaCBiL2luY2x1ZGUvbGludXgv
ZmIuaAppbmRleCA2NjIyNjgyLi5jYjQwMjUwIDEwMDY0NAotLS0gYS9pbmNsdWRlL2xpbnV4L2Zi
LmgKKysrIGIvaW5jbHVkZS9saW51eC9mYi5oCkBAIC0xMTksNiArMTE5LDcgQEAgc3RydWN0IGRl
bnRyeTsKICNkZWZpbmUgRkJfQUNDRUxfTlZfNDAgICAgICAgICAgNDYgICAgICAvKiBuVmlkaWEg
QXJjaCA0MCAgICAgICAgICAgICAgICovCiAjZGVmaW5lIEZCX0FDQ0VMX1hHSV9WT0xBUklfVgk0
NwkvKiBYR0kgVm9sYXJpIFYzWFQsIFY1LCBWOCAgICAgICovCiAjZGVmaW5lIEZCX0FDQ0VMX1hH
SV9WT0xBUklfWgk0OAkvKiBYR0kgVm9sYXJpIFo3ICAgICAgICAgICAgICAgICovCisjZGVmaW5l
IEZCX0FDQ0VMX09NQVAxNjEwCTQ5CS8qIFRJIE9NQVAxNnh4ICAgICAgICAgICAgICAgICAgKi8K
ICNkZWZpbmUgRkJfQUNDRUxfTkVPTUFHSUNfTk0yMDcwIDkwCS8qIE5lb01hZ2ljIE5NMjA3MCAg
ICAgICAgICAgICAgKi8KICNkZWZpbmUgRkJfQUNDRUxfTkVPTUFHSUNfTk0yMDkwIDkxCS8qIE5l
b01hZ2ljIE5NMjA5MCAgICAgICAgICAgICAgKi8KICNkZWZpbmUgRkJfQUNDRUxfTkVPTUFHSUNf
Tk0yMDkzIDkyCS8qIE5lb01hZ2ljIE5NMjA5MyAgICAgICAgICAgICAgKi8KLS0gCjEuNS4wCgo=

------=_Part_17296_8578684.1182861284949--
