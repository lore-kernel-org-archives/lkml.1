Return-Path: <linux-kernel-owner+w=401wt.eu-S1757831AbXFLI4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757831AbXFLI4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 04:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755075AbXFLIzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 04:55:47 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:46772 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757220AbXFLIzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 04:55:46 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       galak@kernel.crashing.org, Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 0/5] Porting RapidIO driver from ppc to powerpc architecture and adding memory mapped RapidIO driver.
Date: Tue, 12 Jun 2007 17:02:15 +0800
Message-Id: <11816389393593-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matt Porter,

These patches are used for supporting RapidIO controllers of Freescale. I ported them from ppc architecture to powerpc architecture and added some new features, such as memory mapped driver.

[PATCH 1/5] Add the explanation and sample of RapidIO DTS sector to the document of booting-without-of.txt file.
[PATCH 2/5] Add RapidIO sector to MPC8641HPCN board dts file.
[PATCH 3/5] Add the platform device support with RapidIO to MPC8641HPCN platform.
[PATCH 4/5] Add RapidIO support to powerpc architecture.
[PATCH 5/5] Add the memory management driver to RapidIO.

Please see below descriptions of these patches:
1. Add the RapidIO driver of-device support.
2. Add the RapidIO driver support to MPC8641HPCN board.
3. Port the RapidIO from ppc to powerpc architecture.
4. Add Memory mapped RapidIO driver.
5. Add the support to multi master ports.
6. Add a simple bitmap RapidIO space allocator driver.
7. Change the RapidIO system size of menuconfig to automatically detection.

Thanks!

Best Regards,
Zhang Wei


