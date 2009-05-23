Return-Path: <linux-kernel-owner+w=401wt.eu-S1757641AbZEWQd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757641AbZEWQd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbZEWQdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:33:00 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48987 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbZEWQc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:32:58 -0400
Message-Id: <20090523162854.599719825@chello.nl>
User-Agent: quilt/0.46-1
Date: Sat, 23 May 2009 18:28:54 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH 0/7] perf counter patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not quite tested, since my upgrade to F11 the userspace bits seem
to segfault within the dynamic linker :/
-- 

