Return-Path: <linux-kernel-owner+w=401wt.eu-S933333AbZKXPIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333AbZKXPIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 10:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933312AbZKXPH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 10:07:58 -0500
Received: from relay1.sgi.com ([192.48.179.29]:57713 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933289AbZKXPHy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 10:07:54 -0500
Message-Id: <20091124150759.827226000@sgi.com>
User-Agent: quilt/0.47-1
Date: Tue, 24 Nov 2009 09:06:26 -0600
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 29/29] GRU - update driver version number
References: <20091124150557.082648000@sgi.com>
Content-Disposition: inline; filename=uv_gru_version
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Update the version number of the GRU driver.

Signed-off-by: Jack Steiner <steiner@sgi.com>


---
 drivers/misc/sgi-gru/grutables.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/misc/sgi-gru/grutables.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/grutables.h	2009-11-20 09:32:39.000000000 -0600
+++ linux/drivers/misc/sgi-gru/grutables.h	2009-11-20 09:32:40.000000000 -0600
@@ -161,7 +161,7 @@ extern unsigned int gru_max_gids;
 #define GRU_MAX_GRUS		(GRU_MAX_BLADES * GRU_CHIPLETS_PER_BLADE)
 
 #define GRU_DRIVER_ID_STR	"SGI GRU Device Driver"
-#define GRU_DRIVER_VERSION_STR	"0.80"
+#define GRU_DRIVER_VERSION_STR	"0.85"
 
 /*
  * GRU statistics.

