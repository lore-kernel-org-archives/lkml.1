Return-Path: <linux-kernel-owner+w=401wt.eu-S937375AbXHLPSp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937375AbXHLPSp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:18:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935704AbXHLPMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:12:34 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47977 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764960AbXHLPMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:12:32 -0400
Message-Id: <20070812151052.704221166@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:10:52 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/4] Linux Kernel Markers
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:12:20 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the latest version of the Linux Kernel Markers.

It applies on top of 2.6.23-rc2-mm2 in this order:

linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-port-blktrace-to-markers.patch

It depends on the Immediate Values and Sorted Seq File patches.

(note the the Immediate values patch depends on the text edit lock patch).

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
