Return-Path: <linux-kernel-owner+w=401wt.eu-S932931AbXIFUI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931AbXIFUI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 16:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932610AbXIFUH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 16:07:28 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40877 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582AbXIFUHZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 16:07:25 -0400
Message-Id: <20070906200550.992474987@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 06 Sep 2007 16:05:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] Sort module list for /proc/modules
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu,  6 Sep 2007 20:07:21 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Here is the updated version of the patchset for 2.6.23-rc4-mm1. It should be
ready to apply. More users (other than module.c and the markers), such as
kallsyms, may also come in a near future.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
