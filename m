Return-Path: <linux-kernel-owner+w=401wt.eu-S1756356AbXGCQtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbXGCQtn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761448AbXGCQr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:47:28 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:46306 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760741AbXGCQr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:47:26 -0400
Message-Id: <20070703164534.492133618@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 03 Jul 2007 12:45:34 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/3] Use DATA_DATA in cris, powerpc and xtensa
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue,  3 Jul 2007 16:46:28 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that these architectures, as of 2.6.22-rc6-mm1, still doesn't use the
DATA_DATA. Here are the patches for this.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
