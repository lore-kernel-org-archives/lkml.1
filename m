Return-Path: <linux-kernel-owner+w=401wt.eu-S1757379AbYJHTnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379AbYJHTnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 15:43:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755948AbYJHTky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 15:40:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:3991 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbYJHTkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 15:40:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U98ymJ9WO0PhgCRUe9iZ4Y5MqqkYV1TrBblkl2RmvtygZO+wqBaljvCThpK8ctmyCo
         8PrZxdAhjKvmHWBe/mzmwdg0JHP8alw8hpJO7L9t1aGIaBswyU25+P3DJJXitD/YkNRv
         iIdZrj9owd9Z2Rtl2tuzHtjaADFA9KrsjnkjY=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Richard A. Holden III" <aciddeath@gmail.com>, alan@lxorguk.ukuu.org.uk
Subject: [PATCH 09/10] ixj: Remove unused macro.
Date: Wed,  8 Oct 2008 14:41:44 -0600
Message-Id: <68f61bde4082cc6405cef40ab800f063c22fb6f6.1223497217.git.aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <c151f6b92c2b5a21d74ac20d7ef57b4960d6935c.1223497217.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
 <b1f8a69aa47d6aab5d5a951bc78c99c26dd67658.1223497216.git.aciddeath@gmail.com>
 <a04aa1aa0a991f7ea2b0bd9649e4197e30b14ac9.1223497216.git.aciddeath@gmail.com>
 <c0839cc2716ec89be7e165ad0d50b6bcf9be00db.1223497216.git.aciddeath@gmail.com>
 <659ee5c8af676929264fafd812d539c372f6ee9d.1223497216.git.aciddeath@gmail.com>
 <8b2fbd3480fa4d2e08da0d1ea5a6f9860e6d8bea.1223497216.git.aciddeath@gmail.com>
 <4f6d77649769072c98fa1e6bcafd963b6b050190.1223497216.git.aciddeath@gmail.com>
 <d9e83f28187798f57dc2174a19eda735af09a90f.1223497217.git.aciddeath@gmail.com>
 <c151f6b92c2b5a21d74ac20d7ef57b4960d6935c.1223497217.git.aciddeath@gmail.com>
In-Reply-To: <cover.1223497216.git.aciddeath@gmail.com>
References: <cover.1223497216.git.aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>
---
 drivers/telephony/ixj.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 3e19357..e502f02 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -275,7 +275,6 @@
 
 #include "ixj.h"
 
-#define TYPE(inode) (iminor(inode) >> 4)
 #define NUM(inode) (iminor(inode) & 0xf)
 
 static int ixjdebug;
-- 
1.5.6.4

