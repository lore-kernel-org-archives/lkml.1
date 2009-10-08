Return-Path: <linux-kernel-owner+w=401wt.eu-S1757017AbZJHCI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbZJHCI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 22:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756787AbZJHCI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 22:08:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756343AbZJHCI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 22:08:58 -0400
Message-Id: <20091008020625.084181867@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 07 Oct 2009 22:06:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 0/2] [GIT PULL][for 2.6.32] tracing: some more fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent2 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent2


Steven Rostedt (1):
      tracing: user local buffer variable for trace branch tracer

Zhenwen Xu (1):
      tracing: fix warning on kernel/trace/trace_branch.c andtrace_hw_branches.c

----
 kernel/trace/trace_branch.c      |    8 +++++---
 kernel/trace/trace_hw_branches.c |    8 +++++---
 2 files changed, 10 insertions(+), 6 deletions(-)
