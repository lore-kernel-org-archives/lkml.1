Return-Path: <linux-kernel-owner+w=401wt.eu-S1757458AbZDGCXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458AbZDGCXT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 22:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbZDGCXJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 22:23:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:44928 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZDGCXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 22:23:07 -0400
Message-Id: <20090407022242.515462242@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 06 Apr 2009 22:22:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] [GIT PULL] more updates to tip/tracing/core
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Frederic Weisbecker (1):
      tracing/ftrace: alloc the started cpumask for the trace file

Nikanth Karthikesan (1):
      Update /debug/tracing/README

Zhaolei (1):
      ftrace: Correct a text align for event format output

----
 kernel/trace/trace.c        |   17 ++++++++++++++---
 kernel/trace/trace_export.c |    2 +-
 2 files changed, 15 insertions(+), 4 deletions(-)
-- 
