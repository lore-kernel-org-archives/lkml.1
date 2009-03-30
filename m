Return-Path: <linux-kernel-owner+w=401wt.eu-S1756146AbZC3Sm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbZC3Sm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 14:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750998AbZC3SmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 14:42:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49638 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbZC3SmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 14:42:16 -0400
Message-Id: <20090330184149.866994402@goodmis.org>
User-Agent: quilt/0.46-1
Date: Mon, 30 Mar 2009 14:41:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 0/2] [GIT PULL] ftrace updates for 2.6.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace


Steven Rostedt (2):
      function-graph: allow unregistering twice
      ring-buffer: do not remove reader page from list on ring buffer free

----
 kernel/trace/ftrace.c      |    4 ++++
 kernel/trace/ring_buffer.c |    1 -
 2 files changed, 4 insertions(+), 1 deletions(-)
-- 
