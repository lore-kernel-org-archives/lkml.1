Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbXE1Ign@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbXE1Ign (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 04:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756900AbXE1Igb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 04:36:31 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:22622 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbXE1Iga (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 04:36:30 -0400
X-IronPort-AV: i="4.14,586,1170651600"; 
   d="scan'208"; a="40300043:sNHT1893719513"
From: Bryan Wu <bryan.wu@analog.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 00/20] Blackfin update for 2.6.22-rc3
Date: Mon, 28 May 2007 16:37:35 +0800
Message-Id: <11803414753217-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

 - Blackfin arch update including BF54x initial supporting
 - Blackfin driver update: serial/spi/rtc
 - Provide new Blackfin watchdog driver
 - binfmt_flat.c for Blackfin arch modification

Thanks a lot
Best Regards,
-Bryan Wu

