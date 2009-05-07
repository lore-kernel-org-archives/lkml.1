Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZEGQXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZEGQXd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754919AbZEGQXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:23:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55754 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392AbZEGQXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:23:05 -0400
Message-Id: <20090507162221.413243886@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 07 May 2009 12:22:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2] [GIT PULL] tracing/ring-buffer: updates to tip
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (2):
      ring-buffer: remove complex calculations in ring-buffer-test
      tracing: append ":*" to internal setting of system events

----
 kernel/trace/ring_buffer_benchmark.c |   37 ++++++---------------------------
 kernel/trace/trace_events.c          |    6 +++-
 2 files changed, 11 insertions(+), 32 deletions(-)
-- 
