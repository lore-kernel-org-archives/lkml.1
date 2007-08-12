Return-Path: <linux-kernel-owner+w=401wt.eu-S935528AbXHLPMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935528AbXHLPMY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936105AbXHLPIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:08:47 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:47593 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936217AbXHLPIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:08:45 -0400
Message-Id: <20070812150702.769065566@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Sun, 12 Aug 2007 11:07:02 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] Immediate Values
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sun, 12 Aug 2007 15:08:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the latest version of immediate values. It applies on 2.6.23-rc2-mm2 in
this order:

immediate-values-global-modules-list-and-mutex.patch
immediate-values-architecture-independent-code.patch
immediate-values-kconfig-embedded.patch
immediate-values-move-kprobes-i386-restore-interrupt-to-kdebug-h.patch
immediate-values-i386-optimization.patch
immediate-values-powerpc-optimization.patch
immediate-values-documentation.patch
#
profiling-use-immediate-values.patch


Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
