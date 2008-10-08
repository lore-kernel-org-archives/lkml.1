Return-Path: <linux-kernel-owner+w=401wt.eu-S1755322AbYJHLIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbYJHLIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 07:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYJHLIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 07:08:41 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:32802 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764AbYJHLIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 07:08:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type;
        b=IT1w8Ogsm5cJDnaCoa6991zWTpwcL5GPw4Ksw0F4PN+BU9AcyLs9hrHtZSxXbroJi7
         2Mf92NmnA/C32Hd01xUs7yCkAUgRi0BT3fzuEXRJ6An0FLRkZvsdZjgLj7KcKvpvTMV3
         Zg1zYt/lEyg3mecwNQS0juvMAHJ06402N7gCc=
Date: Wed, 8 Oct 2008 13:08:06 +0200
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-fbdev-devel@lists.sourceforge.net" 
	<linux-fbdev-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       varenet@parisc-linux.org
Subject: PATCH - New S1D1... Epson frambuffer maintainer
Message-Id: <20081008130806.958423b3.kristoffer.ericson@gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Wed__8_Oct_2008_13_08_06_+0200_r2eVRFw8uQuKY6ke"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Wed__8_Oct_2008_13_08_06_+0200_r2eVRFw8uQuKY6ke
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

I'm stepping up as maintainer for the Epson S1D13XXXFB driver
since I have 2 platforms currently using it.

Signed-off-by: Kristoffer Ericson <Kristoffer.Ericson@gmail.com>
Acked-by: Thibaut Var_ne <varenet@parisc-linux.org>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8dae455..aed3ee5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1610,6 +1610,11 @@ P:	Christopher Hoover
 M:	ch@murgatroid.com, ch@hpl.hp.com
 S:	Maintained
 
+EPSON S1D13XXX FRAMEBUFFER DRIVER
+P:	Kristoffer Ericson
+M:	kristoffer.ericson@gmail.com
+S:	Maintained
+
 ETHEREXPRESS-16 NETWORK DRIVER
 P:	Philip Blundell
 M:	philb@gnu.org


-- 
Kristoffer Ericson <kristoffer.ericson@gmail.com>

--Multipart=_Wed__8_Oct_2008_13_08_06_+0200_r2eVRFw8uQuKY6ke
Content-Type: application/octet-stream;
 name="epson-add-maintainer.patch"
Content-Disposition: attachment;
 filename="epson-add-maintainer.patch"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL01BSU5UQUlORVJTIGIvTUFJTlRBSU5FUlMKaW5kZXggOGRhZTQ1NS4uYWVk
M2VlNSAxMDA2NDQKLS0tIGEvTUFJTlRBSU5FUlMKKysrIGIvTUFJTlRBSU5FUlMKQEAgLTE2MTAs
NiArMTYxMCwxMSBAQCBQOglDaHJpc3RvcGhlciBIb292ZXIKIE06CWNoQG11cmdhdHJvaWQuY29t
LCBjaEBocGwuaHAuY29tCiBTOglNYWludGFpbmVkCiAKK0VQU09OIFMxRDEzWFhYIEZSQU1FQlVG
RkVSIERSSVZFUgorUDoJS3Jpc3RvZmZlciBFcmljc29uCitNOglrcmlzdG9mZmVyLmVyaWNzb25A
Z21haWwuY29tCitTOglNYWludGFpbmVkCisKIEVUSEVSRVhQUkVTUy0xNiBORVRXT1JLIERSSVZF
UgogUDoJUGhpbGlwIEJsdW5kZWxsCiBNOglwaGlsYkBnbnUub3JnCg==

--Multipart=_Wed__8_Oct_2008_13_08_06_+0200_r2eVRFw8uQuKY6ke--
