Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304Ab0CIEyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 23:54:40 -0500
Received: from sh.osrg.net ([192.16.179.4]:32811 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756527Ab0CIEyf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 23:54:35 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: akpm@linux-foundation.org
Cc: James.Bottomley@suse.de, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       rdunlap@xenotime.net, davem@davemloft.net
Subject: [PATCH -mm 3/3] Documentation: rename PCI-DMA-mapping.txt to DMA-API-HOWTO.txt
Date: Tue,  9 Mar 2010 13:53:09 +0900
Message-Id: <1268110389-12444-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.5
In-Reply-To: <1268110389-12444-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1268110389-12444-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 09 Mar 2010 13:54:22 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 .../{PCI/PCI-DMA-mapping.txt => DMA-API-HOWTO.txt} |    0
 Documentation/DMA-API.txt                          |    2 +-
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename Documentation/{PCI/PCI-DMA-mapping.txt => DMA-API-HOWTO.txt} (100%)

diff --git a/Documentation/PCI/PCI-DMA-mapping.txt b/Documentation/DMA-API-HOWTO.txt
similarity index 100%
rename from Documentation/PCI/PCI-DMA-mapping.txt
rename to Documentation/DMA-API-HOWTO.txt
diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index 5e018f6..05e2ae2 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -5,7 +5,7 @@
 
 This document describes the DMA API.  For a more gentle introduction
 of the API (and actual examples) see
-Documentation/PCI/PCI-DMA-mapping.txt.
+Documentation/DMA-API-HOWTO.txt.
 
 This API is split into two pieces.  Part I describes the API.  Part II
 describes the extensions to the API for supporting non-consistent
-- 
1.6.5

