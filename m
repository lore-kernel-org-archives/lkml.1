Return-Path: <linux-kernel-owner+w=401wt.eu-S934390AbYCEAtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934390AbYCEAtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 19:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934886AbYCEAr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 19:47:58 -0500
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2501 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934826AbYCEAr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 19:47:56 -0500
Subject: [PATCH] drivers/char/drm/drm_ioctl.c - use angle brackets for
	include
From: Joe Perches <joe@perches.com>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 16:47:07 -0800
Message-Id: <1204678027.5180.93.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3-1.1mdv2008.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>

drivers/char/drm/drm_ioctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/drm/drm_ioctl.c b/drivers/char/drm/drm_ioctl.c
index 16829fb..281caeb 100644
--- a/drivers/char/drm/drm_ioctl.c
+++ b/drivers/char/drm/drm_ioctl.c
@@ -36,7 +36,7 @@
 #include "drmP.h"
 #include "drm_core.h"
 
-#include "linux/pci.h"
+#include <linux/pci.h>
 
 /**
  * Get the bus id.


