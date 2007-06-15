Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXFOU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXFOU3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753821AbXFOU3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:29:31 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:54892 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754604AbXFOU3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:29:30 -0400
Message-Id: <20070615202310.178466032@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 15 Jun 2007 16:23:10 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] Immediate values for fast branches
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Fri, 15 Jun 2007 20:29:40 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the latest release of the previously called "Conditional Calls"
infrastructure, turned into a static variable synchronized with the load
immediate instructions whenever it is changed. Important changes were made
following the advice received (more details in the specific changelogs). Please
feel free to have a look at this improved version.

It applies at the end of the 2.6.22-rc4-mm2 patch series.

Mathieu


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
