Return-Path: <linux-kernel-owner+w=401wt.eu-S1757076AbYESWFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076AbYESWFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764865AbYESWEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:04:13 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:45007 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764492AbYESWEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:04:11 -0400
Date: Tue, 20 May 2008 01:02:06 +0300
From: Adrian Bunk <bunk@kernel.org>
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] PCI: remove CVS keywords
Message-ID: <20080519220206.GB17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time 
from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/pci/pci.c  |    2 --
 drivers/pci/proc.c |    2 --
 2 files changed, 4 deletions(-)

8dd61bfb8313395b86f7bff14841a302b6711dcf diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index e4548ab..15beaf4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1,6 +1,4 @@
 /*
- *	$Id: pci.c,v 1.91 1999/01/21 13:34:01 davem Exp $
- *
  *	PCI Bus Services, see include/linux/pci.h for further explanation.
  *
  *	Copyright 1993 -- 1997 Drew Eckhardt, Frederic Potter,
diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 963a976..5d77682 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -1,6 +1,4 @@
 /*
- *	$Id: proc.c,v 1.13 1998/05/12 07:36:07 mj Exp $
- *
  *	Procfs interface for the PCI bus.
  *
  *	Copyright (c) 1997--1999 Martin Mares <mj@ucw.cz>

