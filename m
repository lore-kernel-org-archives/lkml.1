Return-Path: <linux-kernel-owner+w=401wt.eu-S1765161AbXGNB2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765161AbXGNB2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764663AbXGNB1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:27:05 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38476 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764743AbXGNB1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:27:01 -0400
Message-Id: <20070714012439.285079881@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:24:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] Immediates Values (real variables)
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:26:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the new version of the immediate values. It should be _must_ more useful
like this: it now provides full variables encoded as load immediates in the
instruction stream. It has been thoroughly tested too.

It applies to 2.6.22-rc6-mm1 (just like the text edit lock)
It depends on the text edit lock patches.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
