Return-Path: <linux-kernel-owner+w=401wt.eu-S1760630AbXIRVPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760630AbXIRVPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754867AbXIRVPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:15:04 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55187 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018AbXIRVPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:15:03 -0400
Message-Id: <20070918211324.161373216@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 17:13:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/4] Linux Kernel Markers for 2.6.23-rc6-mm1
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 18 Sep 2007 21:14:59 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here are the updated Linux Kernel Markers.

It depends on :
Text Edit Lock
Immediate Values
Sorted module list
Merge Kconfig instrumentation menu

It applies to 2.6.23-rc4-mm1, in this order:

linux-kernel-markers-architecture-independent-code.patch
linux-kernel-markers-instrumentation-menu.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-port-blktrace-to-markers.patch

You can find a tarball of this patch and all its dependencies at:
http://ltt.polymtl.ca/markers/markers-patches-for-2.6.23-rc6-mm1-18-09-2007.tar.bz2

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
