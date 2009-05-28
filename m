Return-Path: <linux-kernel-owner+w=401wt.eu-S1761217AbZE1UmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761217AbZE1UmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 16:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757109AbZE1UmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 16:42:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38995 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZE1UmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 16:42:05 -0400
Message-Id: <20090528204128.571984478@goodmis.org>
User-Agent: quilt/0.46-1
Date: Thu, 28 May 2009 16:41:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>
Subject: [PATCH 0/2] [GIT PULL] tracing: fix config options
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/ftrace-1 tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/ftrace-1


Steven Rostedt (2):
      tracing: fix config options to not show when automatically selected
      tracing: combine the default tracers into one config

----
 kernel/trace/Kconfig |   60 +++++++++++++++++++++++++-------------------------
 1 files changed, 30 insertions(+), 30 deletions(-)
-- 
