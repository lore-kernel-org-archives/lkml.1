Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbZEUNQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbZEUNQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753264AbZEUNQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:16:20 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:49427 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZEUNQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:16:19 -0400
Date: Thu, 21 May 2009 09:16:20 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Zhaolei <zhaolei@cn.fujitsu.com>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ftrace: clean up of using
 ftrace_event_enable_disable()
In-Reply-To: <4A14FE45.6070308@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0905210916040.4632@gandalf.stny.rr.com>
References: <4A14FDFE.2080402@cn.fujitsu.com> <4A14FE45.6070308@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 21 May 2009, Zhaolei wrote:

> Always use tracing_stop_cmdline_record() to enable/disable a event.
> 
> Impact: cleanup, no functionality changed

Nice, I'll suck this up too.

-- Steve
