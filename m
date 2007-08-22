Return-Path: <linux-kernel-owner+w=401wt.eu-S1763419AbXHVJH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419AbXHVJH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 05:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758828AbXHVIxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 04:53:45 -0400
Received: from 1wt.eu ([62.212.114.60]:2155 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757670AbXHVIxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 04:53:42 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070822084044.%N@1wt.eu>
References: <20070822083844.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 11:39:39 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Jeff Garzik <jeff@garzik.org>, Chuck Ebbert <cebbert@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [2.6.20.17 review 55/58] pata_atiixp: add SB700 PCI ID
Content-Disposition: inline; filename=0055-pata_atiixp-add-SB700-PCI-ID.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[libata] pata_atiixp: add SB700 PCI ID

>From AMD.

Signed-off-by: Jeff Garzik <jeff@garzik.org>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/ata/pata_atiixp.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index b50ebb6..17d75ec 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -283,6 +283,7 @@ static const struct pci_device_id atiixp[] = {
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP300_IDE), },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP400_IDE), },
 	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP600_IDE), },
+	{ PCI_VDEVICE(ATI, PCI_DEVICE_ID_ATI_IXP700_IDE), },
 
 	{ },
 };
-- 
1.5.2.5

-- 
