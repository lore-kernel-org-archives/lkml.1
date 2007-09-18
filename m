Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbXIRVM3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbXIRVM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 17:12:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbXIRVJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 17:09:51 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54676 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759264AbXIRVJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 17:09:50 -0400
Message-Id: <20070918210912.502772877@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Tue, 18 Sep 2007 17:09:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] Sorted Module List for 2.6.23-rc6-mm1
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Tue, 18 Sep 2007 21:09:46 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the updated sorted module list, required by the linux kernel markers.

It applies to 2.6.23-rc6-mm1 in this order:

seq_file_sorted.patch
module.c-sort-module-list.patch

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
