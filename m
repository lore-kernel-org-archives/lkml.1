Return-Path: <linux-kernel-owner+w=401wt.eu-S1758493AbXIRVKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493AbXIRVKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbXIRVI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:08:57 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54529 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbXIRVI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:08:56 -0400
Message-Id: <20070918210747.828804366@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 17:07:47 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/7] Immediate Values for 2.6.23-rc6-mm1
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 18 Sep 2007 21:08:52 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are the updated immediate values, following recent discussions. The changes
were mostly made to the documentation and to function headers.

It depends on the text edit lock patches.

It applies to 2.6.23-rc6-mm1, in the following order:

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
