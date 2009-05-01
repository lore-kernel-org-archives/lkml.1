Return-Path: <linux-kernel-owner+w=401wt.eu-S1757703AbZEAK0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757703AbZEAK0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 06:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZEAK0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 06:26:15 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45660 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753725AbZEAK0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 06:26:14 -0400
Message-Id: <20090501102315.367605848@chello.nl>
User-Agent: quilt/0.46-1
Date: Fri, 01 May 2009 12:23:15 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/4] perf_counter bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 - fixes a race in the output code
 - x86: fixes a hang in nmi_watchdog=2 vs perf_counters
 - teaches perf-report to handle 0-length files
 - updates the documentation
-- 

