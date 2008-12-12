Return-Path: <linux-kernel-owner+w=401wt.eu-S1759250AbYLLQsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbYLLQsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 11:48:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757773AbYLLQsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 11:48:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:51859 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757716AbYLLQsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 11:48:41 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/4GgIrMsj4CoOU8wpbRUS9AWAxgRCG11PIjNOAl1
	1kREl0RX8IONcS
Date: Fri, 12 Dec 2008 17:48:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/4 v3] i.MX31: dmaengine and framebuffer drivers
Message-ID: <Pine.LNX.4.64.0812121740240.6411@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is version 3 of dmaengine and framebuffer drivers for i.MX31.

Changes since version 2: now uses a tasklet to clean up completed 
transaction descriptors, as suggested by Dan Williams.

Changes since version 1: rebased on the updated dmaengine framework.

Thanks
Guennadi
---
Guennadi Liakhovetski
