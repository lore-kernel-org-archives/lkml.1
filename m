Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZJLJcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZJLJcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 05:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755404AbZJLJcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 05:32:00 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:53288 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755393AbZJLJb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 05:31:59 -0400
MIME-Version: 1.0
In-Reply-To: <31014a580910120227j3023d3f0t947f6feeba427487@mail.gmail.com>
References: <31014a580910120227j3023d3f0t947f6feeba427487@mail.gmail.com>
From: "Mark A. Miller" <mark@mirell.org>
Date: Mon, 12 Oct 2009 04:31:02 -0500
Message-ID: <31014a580910120231p58c4f4ebi122c9232a7c288f3@mail.gmail.com>
Subject: [PATCH] Expose BOOT_RAW Kconfig Symbol
To: linux-kernel@vger.kernel.org
Cc: Rob Landley <rob@landley.net>
Content-Type: multipart/mixed; boundary=0016e6d7eea0c26aff0475b99710
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6d7eea0c26aff0475b99710
Content-Type: text/plain; charset=UTF-8

This is a trivial change, it allows you to enable the BOOT_RAW symbol
on systems that it isn't otherwise the default on.

--
Mark A. Miller
mark@mirell.org

--0016e6d7eea0c26aff0475b99710
Content-Type: application/octet-stream; name="linux-bootraw-kconfig.patch"
Content-Disposition: attachment; filename="linux-bootraw-kconfig.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g0p0t0dm0

RnJvbTogTWFyayBNaWxsZXIgPG1hcmtAbWlyZWxsLm9yZz4KClRoaXMgZXhwb3NlcyB0aGUgQ09O
RklHX0JPT1RfUkFXIHN5bWJvbCBpbiBLY29uZmlnLiBUaGlzIGlzIG5lZWRlZCBvbiBjZXJ0YWlu
IEJyb2FkY29tIGNoaXBzZXRzIHJ1bm5pbmcgQ0ZFIGluIG9yZGVyIHRvIGxvYWQgdGhlIGtlcm5l
bAoKU2lnbmVkLW9mZi1ieTogTWFyayBNaWxsZXIgPG1hcmtAbWlyZWxsLm9yZz4KLS0tCgogYXJj
aC9taXBzL0tjb25maWcgfCAgIDE1ICsrKysrKysrKysrKy0tLQogMSBmaWxlIGNoYW5nZWQsIDEy
IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvYXJjaC9taXBzL0tj
b25maWcgYi9hcmNoL21pcHMvS2NvbmZpZwppbmRleCBmNGFmOTY3Li4wMjM2MDRkIDEwMDY0NAot
LS0gYS9hcmNoL21pcHMvS2NvbmZpZworKysgYi9hcmNoL21pcHMvS2NvbmZpZwpAQCAtNjcwLDkg
KzY3MCw2IEBAIGNvbmZpZyBBUkMKIGNvbmZpZyBBUkNIX01BWV9IQVZFX1BDX0ZEQwogCWJvb2wK
IAotY29uZmlnIEJPT1RfUkFXCi0JYm9vbAotCiBjb25maWcgQ0VWVF9CQ00xNDgwCiAJYm9vbAog
CkBAIC0xODg3LDYgKzE4ODQsMTggQEAgY29uZmlnIFNFQ0NPTVAKIAogCSAgSWYgdW5zdXJlLCBz
YXkgWS4gT25seSBlbWJlZGRlZCBzaG91bGQgc2F5IE4gaGVyZS4KIAorY29uZmlnIEJPT1RfUkFX
CisJYm9vbCAiRW5hYmxlIHRoZSBrZXJuZWwgdG8gYmUgZXhlY3V0ZWQgZnJvbSB0aGUgbG9hZCBh
ZGRyZXNzIgorCWRlZmF1bHQgbgorCWhlbHAKKwkgQWxsb3cgdGhlIGtlcm5lbCB0byBiZSBleGVj
dXRlZCBmcm9tIHRoZSBsb2FkIGFkZHJlc3MgZm9yCisJIGJvb3Rsb2FkZXJzIHdoaWNoIGNhbm5v
dCByZWFkIHRoZSBFTEYgZm9ybWF0LiBUaGlzIHBsYWNlcworCSBhIGp1bXAgdG8gc3RhcnRfa2Vy
bmVsIGF0IHRoZSBsb2FkIGFkZHJlc3MuCisKKwkgSWYgdW5zdXJlLCBzYXkgTi4KKworCisKIGVu
ZG1lbnUKIAogY29uZmlnIExPQ0tERVBfU1VQUE9SVAo=
--0016e6d7eea0c26aff0475b99710--
