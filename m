Return-Path: <linux-kernel-owner+w=401wt.eu-S1756616AbZEHQVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616AbZEHQVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbZEHQVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:21:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55776 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbZEHQVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:21:32 -0400
Message-Id: <20090508162033.397923239@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 May 2009 12:20:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] ring-buffer: fixes suggested by Andrew
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (2):
      ring-buffer: replace constants with time macros in ring-buffer-benchmark
      ring-buffer: check for divide by zero in ring-buffer-benchmark

----
 kernel/trace/ring_buffer_benchmark.c |   18 +++++++++++++-----
 1 files changed, 13 insertions(+), 5 deletions(-)
-- 
