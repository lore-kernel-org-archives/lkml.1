Return-Path: <linux-kernel-owner+w=401wt.eu-S1765350AbXHTUeu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765350AbXHTUeu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764542AbXHTU2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:28:50 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55987 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762645AbXHTU2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:28:48 -0400
Message-Id: <20070820202704.927923667@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:27:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/4] Linux Kernel Markers
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:27:58 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the new version of the kernel markers. Changes since last post:

- Documentation fixes.

Applies to 2.6.23-rc2-mm2, in this order:

linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-port-blktrace-to-markers.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
