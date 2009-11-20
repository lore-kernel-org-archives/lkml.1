Return-Path: <linux-kernel-owner+w=401wt.eu-S1753757AbZKTXqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbZKTXqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 18:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753673AbZKTXqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 18:46:11 -0500
Received: from mail-px0-f204.google.com ([209.85.216.204]:43807 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZKTXqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 18:46:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=EuNl03X9/g7VHMgpzOsaQ068Fzn0n2U1BpV/tZn356FqA7YDyn5zM9bELiMe5oFCn5
         8wd9weq6pAo11p65sAkEs0gVzmxU/+xGxRWL6yaSavIXP2Smg7BD2hrk08T8ApaGmyLP
         OveIlpAjxzxx39f6RcZjWFb0OZ/SXzrGx3jas=
From: Bruce Beare <bbeare1@gmail.com>
To: gregkh@suse.de
Cc: wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, Bruce Beare <bbeare1@gmail.com>
Subject: [PATCH 1/3] Cleanup: code indent warning messages (use tabs instead of leading spaces).
Date: Fri, 20 Nov 2009 15:46:09 -0800
Message-Id: <1258760771-24311-2-git-send-email-bbeare1@gmail.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1258760771-24311-1-git-send-email-bbeare1@gmail.com>
References: <1258760771-24311-1-git-send-email-bbeare1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bruce Beare <bbeare1@gmail.com>
---
 drivers/staging/comedi/drivers/pcmad.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/pcmad.c b/drivers/staging/comedi/drivers/pcmad.c
index acac670..202bfd4 100644
--- a/drivers/staging/comedi/drivers/pcmad.c
+++ b/drivers/staging/comedi/drivers/pcmad.c
@@ -34,11 +34,11 @@ Configuration options:
   [0] - I/O port base
   [1] - unused
   [2] - Analog input reference
-          0 = single ended
-          1 = differential
+	  0 = single ended
+	  1 = differential
   [3] - Analog input encoding (must match jumpers)
-          0 = straight binary
-          1 = two's complement
+	  0 = straight binary
+	  1 = two's complement
 */
 
 #include <linux/interrupt.h>
-- 
1.6.2.5

