Return-Path: <linux-kernel-owner+w=401wt.eu-S1753581AbZAZCE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753581AbZAZCE6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2009 21:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZAZCEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Jan 2009 21:04:47 -0500
Received: from vps1.tull.net ([66.180.172.116]:36444 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750868AbZAZCEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2009 21:04:47 -0500
From: Nick Andrew <nick@nick-andrew.net>
Subject: [TRIVIAL PATCH 10/20] Fix misspelling of firmware in pci.c
To: Trivial Kernel Patches <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 26 Jan 2009 13:04:39 +1100
Message-ID: <20090126020439.15168.46281.stgit@marcab.local.tull.net>
In-Reply-To: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
References: <20090126015921.15168.97302.stgit@marcab.local.tull.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix misspelling of firmware in pci.c

Signed-off-by: Nick Andrew <nick@nick-andrew.net>
---

 drivers/pci/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e491fde..ab2aa4a 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -544,7 +544,7 @@ void pci_update_current_state(struct pci_dev *dev, pci_power_t state)
  * @dev: PCI device to handle.
  * @state: PCI power state (D0, D1, D2, D3hot) to put the device into.
  *
- * Transition a device to a new power state, using the platform formware and/or
+ * Transition a device to a new power state, using the platform firmware and/or
  * the device's PCI PM registers.
  *
  * RETURN VALUE:

