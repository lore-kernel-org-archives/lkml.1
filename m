Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbXHTU2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbXHTU2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 16:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763768AbXHTU0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 16:26:11 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55234 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764194AbXHTU0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 16:26:09 -0400
Message-Id: <20070820202355.684760993@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 20 Aug 2007 16:23:55 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] Immediate Values
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 20 Aug 2007 20:25:36 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Changelog since the last post:
- Adapt to the new text edit lock.
- Add more test results to Documentation/immediate.txt

Applies to 2.6.23-rc2-mm2, depends on the Text Edit Lock patchset.

Patch order:

immediate-values-global-modules-list-and-mutex.patch
immediate-values-architecture-independent-code.patch
immediate-values-kconfig-embedded.patch
immediate-values-move-kprobes-i386-restore-interrupt-to-kdebug-h.patch
immediate-values-i386-optimization.patch
immediate-values-powerpc-optimization.patch
immediate-values-documentation.patch
profiling-use-immediate-values.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
