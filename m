Return-Path: <linux-kernel-owner+w=401wt.eu-S1756703AbZBKBia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703AbZBKBia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 20:38:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbZBKBiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 20:38:21 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:34237 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbZBKBiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 20:38:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=EgrB/SnusAvEshCNLMfyGracQQIPlXzv1mzDjlgvIt8sMANR1CLAhrGspQwQWyMIQr
         a4l+J9Cdh8C2O4cr/grooZRxVoVUwaJg99awls3nASrVPu/HKNf1VvAORyXZCtvQBhjK
         aZkNDBNjOpYuIgycpTlX6r0EQLS50SwqMc4Fw=
MIME-Version: 1.0
Date: Tue, 10 Feb 2009 21:38:19 -0400
X-Google-Sender-Auth: a3bbcc8ff90c2a11
Message-ID: <177c2b150902101738o207be1c5p7f2fc998f09509f3@mail.gmail.com>
Subject: [PATCH] Fixed the c-qcam source code path in the linux kernel tree.
From: Mhayk Whandson <eu@mhayk.com.br>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed the c-qcam source code path in the linux kernel tree.

Signed-off-by: Mhayk Whandson <eu@mhayk.com.br>
---
 Documentation/video4linux/CQcam.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/video4linux/CQcam.txt
b/Documentation/video4linux/CQcam.txt
index 04986ef..d230878 100644
--- a/Documentation/video4linux/CQcam.txt
+++ b/Documentation/video4linux/CQcam.txt
@@ -18,8 +18,8 @@ Table of Contents

 1.0 Introduction

-  The file ../drivers/char/c-qcam.c is a device driver for the
-Logitech (nee Connectix) parallel port interface color CCD camera.
+  The file ../../drivers/media/video/c-qcam.c is a device driver for
+the Logitech (nee Connectix) parallel port interface color CCD camera.
 This is a fairly inexpensive device for capturing images.  Logitech
 does not currently provide information for developers, but many people
 have engineered several solutions for non-Microsoft use of the Color
-- 

-- 
Mhayk Whandson
Linux User #413723
E-mail: eu@mhayk.com.br
