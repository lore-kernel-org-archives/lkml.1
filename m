Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYFDCFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYFDCFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 22:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbYFDCFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 22:05:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:35242 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbYFDCFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 22:05:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=NQA5Ti5/0ILC3Ghu402oeiNMonEhLKZpdYtdBOPU69JNlktN7TFeyGoOBbflQkC2vrE+fWh55njD6NIF6Wd4bW7f/zNg6Y6oNgIhscqPOxF3ET+4/iVM6XBuMPOrbkvWQ3vnqqXJtCrbUXrQBiokLiWKnKBlIjDuS/7QKnM9vec=
Message-ID: <4845F86E.9020909@gmail.com>
Date: Wed, 04 Jun 2008 10:05:34 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Nicolas Pitre <nico@cam.org>
Subject: [PATCH] MAINTAINERS: update maintainership of pxa2xx/pxa3xx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric Miao <eric.miao@marvell.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Nicolas Pitre <nico@marvell.com>
---
 MAINTAINERS |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c68a118..93b0e25 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3303,9 +3303,11 @@ L:	video4linux-list@redhat.com
 W:	http://www.isely.net/pvrusb2/
 S:	Maintained
 
-PXA2xx SUPPORT
-P:	Nicolas Pitre
-M:	nico@cam.org
+PXA2xx/PXA3xx SUPPORT
+P:	Eric Miao
+M:	eric.miao@marvell.com
+P:	Russell King
+M:	linux@arm.linux.org.uk
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
 
-- 
1.5.4.3

