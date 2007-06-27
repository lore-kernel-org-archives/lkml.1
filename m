Return-Path: <linux-kernel-owner+w=401wt.eu-S1754706AbXF0I2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706AbXF0I2n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 04:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbXF0I2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 04:28:33 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:53156 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbXF0I2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 04:28:32 -0400
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       galak@kernel.crashing.org, wei.zhang@freescale.com
Subject: [PATCH 0/5 v2] Porting RapidIO driver from ppc to powerpc architecture and adding memory mapped RapidIO driver.
Date: Wed, 27 Jun 2007 16:35:43 +0800
Message-Id: <11829333481420-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Matt Porter,

These are the version 2 patches for RapidIO with dts update and some minor fixups.

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




