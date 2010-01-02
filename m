Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934Ab0ABUSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab0ABUSp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 15:18:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599Ab0ABUSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 15:18:44 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34964 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446Ab0ABUSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 15:18:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Pa+EgrUpGHqstvm7wwU5+nWuPOa1KLBWkTxIg3MF7jzHWyss26/zau+KP6WCHgpT9H
         eYV9QZPAq2BRNOGGnbXTJAkaJ3IbBYhMY0S/rqwWoa8RaXhlSRvd2EEd9YFSzR3xmSiE
         o+L4+rckRyBYu87WOjk1LkGWIvteo08SRgmEk=
MIME-Version: 1.0
Date: Sun, 3 Jan 2010 00:18:42 +0400
Message-ID: <1a297b361001021218q609696e7n3e7f5084287ba3eb@mail.gmail.com>
Subject: staging Patch 04/04: Crystal HD
From: Manu Abraham <abraham.manu@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary=0016364d1fddce78c7047c343100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364d1fddce78c7047c343100
Content-Type: text/plain; charset=ISO-8859-1



--0016364d1fddce78c7047c343100
Content-Type: text/x-patch; charset=US-ASCII; name="0004--Crystal-HD-Add-TODO.patch"
Content-Disposition: attachment; filename="0004--Crystal-HD-Add-TODO.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g3yucbx31

RnJvbSBhNDk1N2Q3ZDI1NWRlYzZkZWM1YjhmYmQ4MTlmZjg0YmQ4YTBjMGVmIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYW51IEFicmFoYW0gPGFicmFoYW0ubWFudUBnbWFpbC5jb20+
CkRhdGU6IFN1biwgMyBKYW4gMjAxMCAwMDowNTozMCArMDQwMApTdWJqZWN0OiBbUEFUQ0hdIFtD
cnlzdGFsIEhEXSBBZGQgVE9ETwoKU2lnbmVkLW9mZi1ieTogTWFudSBBYnJhaGFtIDxhYnJhaGFt
Lm1hbnVAZ21haWwuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy9jcnlzdGFsLWhkL1RPRE8gfCAg
IDE0ICsrKysrKysrKysrKysrCiAxIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDAg
ZGVsZXRpb25zKC0pCiBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9zdGFnaW5nL2NyeXN0YWwt
aGQvVE9ETwoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy9jcnlzdGFsLWhkL1RPRE8gYi9k
cml2ZXJzL3N0YWdpbmcvY3J5c3RhbC1oZC9UT0RPCm5ldyBmaWxlIG1vZGUgMTAwNjQ0CmluZGV4
IDAwMDAwMDAuLmUwYjgxOTEKLS0tIC9kZXYvbnVsbAorKysgYi9kcml2ZXJzL3N0YWdpbmcvY3J5
c3RhbC1oZC9UT0RPCkBAIC0wLDAgKzEsMTQgQEAKKyAtIFRlc3RpbmcKKyAtIENsZWFudXAgcmV0
dXJuIGNvZGVzCisgLSBDbGVhbnVwIHR5cGVkZWZzCisgLSBDbGVhbnVwIGFsbCBXSU4qIHJlZmVy
ZW5jZXMKKyAtIEFsbG9jYXRlIGFuIEFjY2VsZXJhdG9yIGRldmljZSBjbGFzcyBzcGVjaWZpYyBN
YWpvciBudW1iZXIsCisgICBzaW5jZSB3ZSBkb24ndCBoYXZlIGFueSBvdGhlciBvcGVuIHNvdXJj
ZWQgYWNjZWxlcmF0b3JzLCBpdCBpcyB0aGUgb25seQorICAgb25lIGluIHRoYXQgY2F0ZWdvcnkg
Zm9yIG5vdy4KKyAgIEEgc29tZXdoYXQgc2ltaWxhciBkZXZpY2UgaXMgdGhlIERYUjIvMworCitQ
bGVhc2Ugc2VuZCBwYXRjaGVzIHRvOgorR3JlZyBLcm9haC1IYXJ0bWFuIDxncmVnQGtyb2FoLmNv
bT4KK05hcmVuIFNhbmthciA8bnNhbmthckBicm9hZGNvbS5jb20+CitQcmFzYWQgQm9saXNldHR5
IDxwcmFzYWRiQGJyb2FkY29tLmNvbT4KK01hbnUgQWJyYWhhbSA8YWJyYWhhbS5tYW51QGdtYWls
LmNvbT4KLS0gCjEuNS42Cgo=
--0016364d1fddce78c7047c343100--
