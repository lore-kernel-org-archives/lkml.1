Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720AbYLJKgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720AbYLJKgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 05:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754922AbYLJKfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 05:35:52 -0500
Received: from mail.gmx.net ([213.165.64.20]:56022 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754876AbYLJKfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 05:35:51 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+mIvBYMwymFif4f6bQcmZzsXV3F4Em8261YWt8wR
	R4BWyBYGGoKnQk
Date: Wed, 10 Dec 2008 11:35:53 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
cc: linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 0/4 v2] i.MX31: dmaengine and framebuffer drivers
Message-ID: <Pine.LNX.4.64.0812101122250.4578@axis700.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the second version of the dmaengine and framebuffer for i.MX31 and 
its Image Processing Unit patch-series. Being based on linux-next of 08.12 
it now uses the updated dmaengine API, still, patch 1 adds the discussed 
tx_free link to the descriptor struct. Please, review and comment. I 
understand we have little time left for the next merge window, but as this 
is a new driver, and hence cannot cause regressions, I hope to get it in 
for 2.6.29.

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.

DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
