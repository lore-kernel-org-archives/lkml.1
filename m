Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbXFOUhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbXFOUhL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXFOUg5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:36:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:56583 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbXFOUg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:36:57 -0400
Message-Id: <20070615202959.316963297@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 15 Jun 2007 16:29:59 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/5] Linux Kernel Markers
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 15 Jun 2007 20:36:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the latest release of the Linux Kernel Markers, adapted to use the new
"immediate values" infrastructure to provide low impact when compiled-in but
disabled.

It applies at the end of the 2.6.22-rc4-mm2 series, after the "immediate values"
patches, in this order:

use-extra_rwdata-in-architectures.patch
#
linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-port-blktrace-to-markers.patch

Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
