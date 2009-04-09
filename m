Return-Path: <linux-kernel-owner+w=401wt.eu-S1759591AbZDID6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591AbZDID6h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 23:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757269AbZDID61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 23:58:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60909 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbZDID60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 23:58:26 -0400
Message-ID: <49DD728D.8030608@cn.fujitsu.com>
Date: Thu, 09 Apr 2009 11:59:09 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Pekka Paalanen <pq@iki.fi>
Subject: Re: [PATCH][RESEND] tracing: consolidate documents
References: <49DD6E2B.6090200@cn.fujitsu.com> <49DD70E0.9080302@cn.fujitsu.com>
In-Reply-To: <49DD70E0.9080302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> Move tracepoints.txt, ftrace.txt and mmiotrace.txt to the new
> directory trace/
> 

Should we also move kmemtrace.txt to trace/, or leave it in vm/?

> I don't find any references to those documents in both source
> files and documents, so no extra work needs to be done.
> 

