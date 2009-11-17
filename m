Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbZKQPAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbZKQPAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZKQPAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:00:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54227 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752631AbZKQPAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:00:37 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/4] Series short description
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Date: Tue, 17 Nov 2009 14:44:28 +0000
Message-ID: <20091117144413.15356.34793.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series implements...

---

Alan Cox (4):
      pata: Update experimental tags
      cmd64x: implement serialization as per notes
      pata_sis: Implement MWDMA for the UDMA 133 capable chips
      pata_via: Blacklist some combinations of Transcend Flash and via


 drivers/ata/Kconfig       |    8 +--
 drivers/ata/pata_cmd64x.c |  132 ++++++++++++++++++++++++++++++++++++++++++---
 drivers/ata/pata_sis.c    |   88 +++++++++++++++++++++++-------
 drivers/ata/pata_via.c    |   27 +++++++++
 4 files changed, 222 insertions(+), 33 deletions(-)

-- 
Signature
