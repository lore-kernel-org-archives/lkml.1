Return-Path: <linux-kernel-owner+w=401wt.eu-S1760492AbZAMN1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760492AbZAMN1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759881AbZAMN1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:27:23 -0500
Received: from smtp.nokia.com ([192.100.122.230]:56009 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756339AbZAMN1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:27:22 -0500
From: Adrian Hunter <ext-adrian.hunter@nokia.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Adrian Hunter <ext-adrian.hunter@nokia.com>,
       linux-omap Mailing List <linux-omap@vger.kernel.org>
Date: Tue, 13 Jan 2009 15:38:27 +0200
Message-Id: <20090113133827.29474.92645.sendpatchset@ahunter-laptop>
Subject: [PATCH 0/2] omap_hsmmc patches
X-OriginalArrivalTime: 13 Jan 2009 13:26:15.0746 (UTC) FILETIME=[82CD4A20:01C97582]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are two patches for omap_hsmmc.  They are applied
on top of Jean Pihet's "OMAP: MMC: recover from transfer
failures" patch, which is here:

http://marc.info/?l=linux-omap&m=123141577308177&w=2
