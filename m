Return-Path: <linux-kernel-owner+w=401wt.eu-S1765244AbXGNBc1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765244AbXGNBc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:32:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765230AbXGNB2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:28:41 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38655 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765514AbXGNB2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:28:39 -0400
Message-Id: <20070714012642.499375439@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:26:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] Immediate Values - in kernel users
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:27:43 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the first users of the immediate values : f00f bug handler and
profiling.

It applies to 2.6.22-rc6-mm1 and depends on the Immediate Values.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
