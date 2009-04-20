Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbZDTPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbZDTPoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755793AbZDTPoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 11:44:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:57485 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755684AbZDTPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 11:44:04 -0400
Message-Id: <20090420154325.698204138@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 20 Apr 2009 11:43:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] [GIT PULL] tracing: config updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (3):
      tracing: change branch profiling to a choice selection
      tracing: create menuconfig for tracing infrastructure
      tracing: rename EVENT_TRACER config to ENABLE_EVENT_TRACING

----
 kernel/trace/Kconfig |   54 +++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 45 insertions(+), 9 deletions(-)
-- 
