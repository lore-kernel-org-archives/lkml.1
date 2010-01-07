Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579Ab0AGCBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0AGCBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756561Ab0AGCBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:01:05 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34937 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab0AGCBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:01:03 -0500
X-Authority-Analysis: v=1.0 c=1 a=gYdIBD-p2Q0A:10 a=VwQbUJbxAAAA:8 a=0eKvUmC5SNl-zE92HwgA:9 a=h1OeJRk-bKPiYllmCcD44jLMH2IA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Message-Id: <20100107015920.827200859@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 Jan 2010 20:59:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/2][GIT PULL][2.6.33] ring-buffer: urgent changes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/urgent


David Sharp (1):
      ring-buffer: Wrap a list.next reference with rb_list_head()

Steven Rostedt (1):
      ring-buffer: Add rb_list_head() wrapper around new reader page next field

----
 kernel/trace/ring_buffer.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
