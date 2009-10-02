Return-Path: <linux-kernel-owner+w=401wt.eu-S932200AbZJBBeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932200AbZJBBeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932179AbZJBBec
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:34:32 -0400
Received: from kroah.org ([198.145.64.141]:33629 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932173AbZJBBe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:34:29 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:28 2009
Message-Id: <20091002012428.000466024@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:18:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jay Sternberg <jay.e.sternberg@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [133/136] iwlwifi: update 1000 series API version to match firmware
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=iwlwifi-update-1000-series-api-version-to-match-firmware.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jay Sternberg <jay.e.sternberg@intel.com>

commit cce53aa347c1e023d967b1cb1aa393c725aedba5 upstream.

firmware file now contains build number so API needs to be updated.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -46,7 +46,7 @@
 #include "iwl-5000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL1000_UCODE_API_MAX 2
+#define IWL1000_UCODE_API_MAX 3
 
 /* Lowest firmware API version supported */
 #define IWL1000_UCODE_API_MIN 1


