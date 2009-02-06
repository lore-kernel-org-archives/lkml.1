Return-Path: <linux-kernel-owner+w=401wt.eu-S1756680AbZBFHL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680AbZBFHL3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZBFHLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:11:17 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:1470 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbZBFHLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:11:16 -0500
X-IronPort-AV: E=Sophos;i="4.37,390,1231131600"; 
   d="scan'208";a="82422004"
From: Bryan Wu <cooloney@kernel.org>
To: dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 00/20] Blackfin SPI Driver fixing and updates
Date: Fri,  6 Feb 2009 15:12:48 +0800
Message-Id: <1233904388-5765-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Dear David and Andrew,

I updates this whole Blackfin SPI Driver patches (20 patches) as we
discussed in LKML.

Normally updates the comments and fold patch "Blackfin SPI Driver: add
comment about full duplex dma according to David Brownell" to
"Blackfin SPI Driver: ensure cache coherency before doing DMA".

Thanks a lot
-Bryan
