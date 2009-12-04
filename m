Return-Path: <linux-kernel-owner+w=401wt.eu-S1755713AbZLDSoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbZLDSoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754393AbZLDSoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:44:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:50010 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754222AbZLDSoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:44:15 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX19kIbBNM61kleHTuX4Q+ZAGCy21APnNSIZm7GMjNQ
	W8k5g2kUYhEwDD
Date: Fri, 4 Dec 2009 19:44:35 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: Dan Williams <dan.j.williams@intel.com>, linux-sh@vger.kernel.org
Subject: [PATCH 0/5] sh: fix the shdma driver, improve dmatest, support sh7724
Message-ID: <Pine.LNX.4.64.0912041936541.3981@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.77
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Not all of these patches are connected, only the ones, affecting the same 
file should be applied in a specific order, otherwise the patches are 
independent and can be applied separately.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
