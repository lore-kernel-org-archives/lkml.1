Return-Path: <linux-kernel-owner+w=401wt.eu-S1761128AbXGaNJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761128AbXGaNJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 09:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756868AbXGaNJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 09:09:05 -0400
Received: from host86-137-100-191.range86-137.btcentralplus.com ([86.137.100.191]:42959
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754083AbXGaNJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 09:09:04 -0400
X-Greylist: delayed 903 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Jul 2007 09:09:04 EDT
From: jack@hawkeye.stone.uk.eu.org
Message-Id: <20070731125316.860150000@hawkeye.stone.uk.eu.org>
User-Agent: quilt/0.46-1
Date: Tue, 31 Jul 2007 13:53:16 +0100
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [Patch 00/16] Remove unnecessary kmalloc casts
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series removes unnecessary kmalloc casts from various portions
of the kernel.

Jack Stone

-- 
