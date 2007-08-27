Return-Path: <linux-kernel-owner+w=401wt.eu-S1760713AbXH0QKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760713AbXH0QKk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 12:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758979AbXH0QCT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 12:02:19 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:44204 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759325AbXH0QCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 12:02:17 -0400
Message-Id: <20070827155910.336723755@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Mon, 27 Aug 2007 11:59:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] Immediate Values
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Mon, 27 Aug 2007 16:02:12 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are the updated immediate values for 2.6.23-rc3-mm1. It depends on "Text
Edit Lock".

The example user is the scheduler profiling, but I plan to use it mainly for my
linux kernel markers. Immediate values should prove themselves useful in
situation where features, such as profiling, are rarely used, but should
nevertheless be compiled in a distribution kernel because of their usefulness to
provide useful profiling information.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
