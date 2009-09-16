Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZIPS5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZIPS5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 14:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947AbZIPS5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 14:57:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:59112 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848AbZIPS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 14:57:11 -0400
Message-Id: <20090916185546.986682049@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Sep 2009 14:55:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: more update for 2.6.32
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

These patches are still for v2.6.32. They fix bugs and add documentation.
Including the patches in core, core2, and core3, which this is built upon.

Please pull the latest tip/tracing/core4 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core4


Atsushi Tsuji (1):
      tracing: Fix minor bugs for __unregister_ftrace_function_probe

Steven Rostedt (1):
      tracing: remove notrace from __kprobes annotation

----
 include/linux/kprobes.h |    4 ++--
 kernel/trace/ftrace.c   |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)
