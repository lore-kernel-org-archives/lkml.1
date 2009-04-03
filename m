Return-Path: <linux-kernel-owner+w=401wt.eu-S935399AbZDCQVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935399AbZDCQVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936749AbZDCQSV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:18:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41462 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936740AbZDCQSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:18:20 -0400
Date: Fri, 3 Apr 2009 12:18:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] tracing/ftrace: fix missing include string.h
In-Reply-To: <1238160130-7437-1-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0904031218040.21481@gandalf.stny.rr.com>
References: <1238159920-7411-1-git-send-email-fweisbec@gmail.com> <1238160130-7437-1-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 27 Mar 2009, Frederic Weisbecker wrote:

> Building a kernel with tracing can raise the following warning on
> tip/master:
> 
> kernel/trace/trace.c:1249: error: implicit declaration of function 'vbin_printf'
> 
> We are missing an include to string.h
> 
> [v2: add reported-by]
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Thanks, applied.

-- Steve

