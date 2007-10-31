Return-Path: <linux-kernel-owner+w=401wt.eu-S1755576AbXJaBEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576AbXJaBEk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753793AbXJaBE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:04:29 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59386 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbXJaBE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:04:28 -0400
Message-Id: <20071031010345.301342580@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 30 Oct 2007 21:03:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: linux-kernel@vger.kernel.org
Subject: [patch 0/4] Add ARCH_SUPPORTS_KPROBES (take 2)
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed, 31 Oct 2007 01:04:26 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

take 2, using def_bool this time.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
