Return-Path: <linux-kernel-owner+w=401wt.eu-S1755503AbXIYMNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbXIYMNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754858AbXIYMNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:13:22 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:59165 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272AbXIYMNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:13:20 -0400
Message-Id: <20070925121145.262664884@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 25 Sep 2007 08:11:45 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: [patch 0/5] Linux Kernel Markers (redux)
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 25 Sep 2007 12:12:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Following Christoph's usual nitpicking and Randy's suggestions to put the sample
code in the new samples/ kernel directory, I made modifications to the markers.
The result is that the marker code holds into a single patch; other patches are
for menus, documentation and samples.

Here is the updated version for 2.6.23-rc8-mm1.

It applies in this order:

kconfig-instrumentation.patch
linux-kernel-markers.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-documentation.patch

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
