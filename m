Return-Path: <linux-kernel-owner+w=401wt.eu-S1759427AbZACEhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759427AbZACEhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 23:37:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbZACEhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 23:37:09 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:13605 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZACEhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 23:37:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=BDtxw9kKjV6z4//Y2a3N4AK/s4qAElaZ4LVOMlbaYSP8tknlQahQgDnm+lnh/pFzWd
         CtX37FVmEGJWLVowP4ZAmWeKPyyN1CzzI38PmdCQqMvrjgfmQp/XPMOR3MKfIUIbu9eE
         x1PnK26FoPLJ2jU7Rc6kcoIfXropH+rc6/+YE=
Message-ID: <d204e3110901022037i4c0e077ck6cefcf35f6048318@mail.gmail.com>
Date: Sat, 3 Jan 2009 12:37:06 +0800
From: "Baodong Chen" <chenbdchenbd@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation/x86/boot.txt:payload length was changed to payload_length
Cc: trivial@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Baodong Chen <[email]chenbdchenbd@gmail.com[email]>

---
 Documentation/x86/boot.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index fcdc62b..7b4596a 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -44,7 +44,7 @@ Protocol 2.07:	(Kernel 2.6.24) Added paravirtualised
boot protocol.
		and KEEP_SEGMENTS flag in load_flags.

 Protocol 2.08:	(Kernel 2.6.26) Added crc32 checksum and ELF format
-		payload. Introduced payload_offset and payload length
+		payload. Introduced payload_offset and payload_length
		fields to aid in locating the payload.

 Protocol 2.09:	(Kernel 2.6.26) Added a field of 64-bit physical
--
1.5.3.3
