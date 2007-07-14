Return-Path: <linux-kernel-owner+w=401wt.eu-S937635AbXGNBhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937635AbXGNBhY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765848AbXGNBcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:32:01 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:39128 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936924AbXGNBby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:31:54 -0400
Message-Id: <20070714012914.508504384@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:29:14 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/4] Linux Kernel Markers
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:30:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the latest version of the Linux Kernel Markers. I removed superfluous
features that brought more complexity than needed.

It applies to 2.6.22-rc6-mm1.
It depends on the Immediate Values.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
