Return-Path: <linux-kernel-owner+w=401wt.eu-S1757146AbZC3E4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146AbZC3E4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 00:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755597AbZC3Ezv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 00:55:51 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:56663 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbZC3Ezu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 00:55:50 -0400
From: Gautham R Shenoy <ego@in.ibm.com>
Subject: [PATCH] sched: Print sched_group::__cpu_power in sched_domain_debug.
To: linux-kernel@vger.kernel.org
Cc: "Ingo Molnar" <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 30 Mar 2009 10:25:15 +0530
Message-ID: <20090330045321.2869.9284.stgit@sofia.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A simple patch to print the value of __cpu_power in sched_domain_debug.

---

Gautham R Shenoy (1):
      sched: Print sched_group::__cpu_power in sched_domain_debug.


 kernel/sched.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

-- 
Thanks and Regards
gautham.
