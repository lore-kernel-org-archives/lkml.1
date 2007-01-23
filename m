Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbXAWA1I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbXAWA1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 19:27:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXAWA1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 19:27:08 -0500
Received: from mx2.suse.de ([195.135.220.15]:37674 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522AbXAWA1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 19:27:07 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@osdl.org>
Date: Tue, 23 Jan 2007 11:26:42 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 4] md: Introduction - Assorted bugfixes
Message-ID: <20070123112437.29357.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 4 patches suitable for inclusion in 2.6.20.

Thanks,
NeilBrown

 [PATCH 001 of 4] md: Update email address and status for MD in MAINTAINERS.
 [PATCH 002 of 4] md: Make 'repair' actually work for raid1.
 [PATCH 003 of 4] md: Make sure the events count in an md array never returns to zero.
 [PATCH 004 of 4] md: Avoid reading past the end of a bitmap file.
