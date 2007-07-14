Return-Path: <linux-kernel-owner+w=401wt.eu-S1764633AbXGNBYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764633AbXGNBYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 21:24:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761811AbXGNBYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 21:24:17 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38060 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758508AbXGNBYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 21:24:16 -0400
Message-Id: <20070714012133.612727310@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 13 Jul 2007 21:21:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] Text Edit Lock
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Sat, 14 Jul 2007 01:24:11 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

After refactoring of architecture independant code (mutex to protect text
edition) vs architecture dependant code (marking/unmarking pages RW) and
thorough testing, here is the new version of the text edit lock.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
