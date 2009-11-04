Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbZKDGsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbZKDGsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:48:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752830AbZKDGst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:48:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:45663 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZKDGsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:48:46 -0500
Message-Id: <20091104064825.546743711@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 04 Nov 2009 01:48:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL][for v2.6.32] tracing: urgent fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


Lai Jiangshan (1):
      ring-buffer: Synchronize resizing buffer with reader lock

Li Zefan (1):
      ftrace: Fix unmatched locking in ftrace_regex_write()

----
 kernel/trace/ftrace.c      |    6 +++---
 kernel/trace/ring_buffer.c |    2 ++
 2 files changed, 5 insertions(+), 3 deletions(-)

