Return-Path: <linux-kernel-owner+w=401wt.eu-S1755305AbYGIPBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbYGIPBi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 11:01:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYGIPBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 11:01:30 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:35937 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbYGIPBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 11:01:30 -0400
Message-Id: <20080709145929.352201601@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Wed, 09 Jul 2008 10:59:29 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [patch 00/15] Tracepoints v3 for linux-next
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Wed,  9 Jul 2008 15:00:44 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the 3rd round of tracepoints patch submisison. The instrumentation
sites the more likely to come to a quick agreement has been selected in this
first step. The tracepoint infrastructure, heavily inspired from the kernel
markers, seems pretty solid and went through a thorough review by Masami.

This patchset applies over patch-v2.6.26-rc9-next-20080709.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
