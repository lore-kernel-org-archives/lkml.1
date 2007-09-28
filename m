Return-Path: <linux-kernel-owner+w=401wt.eu-S1760250AbXI1OcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250AbXI1OcR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 10:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbXI1OcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 10:32:06 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:49620 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbXI1OcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:32:05 -0400
Message-Id: <20070928142845.795281397@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 28 Sep 2007 10:28:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/5] Linux Kernel Markers for 2.6.23-rc8-mm2
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 28 Sep 2007 14:31:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are the Linux Kernel Markers for 2.6.23-rc8-mm2. The only change that has
been made since 2.6.23-rc8-mm1 is to integrate the updated samples menu.

The patches apply in the following order:

kconfig-instrumentation.patch
linux-kernel-markers.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-documentation.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
