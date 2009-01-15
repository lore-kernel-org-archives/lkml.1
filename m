Return-Path: <linux-kernel-owner+w=401wt.eu-S1763397AbZAOK05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763397AbZAOK05 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 05:26:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763203AbZAOK0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 05:26:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763188AbZAOK0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 05:26:42 -0500
Date: Thu, 15 Jan 2009 05:26:41 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>
cc: Ingo Molnar <mingo@elte.hu>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing/ftrace: add missing unlock in
 register_stat_tracer()
In-Reply-To: <alpine.DEB.1.10.0901150524340.716@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0901150525510.716@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0901142056470.22004@gandalf.stny.rr.com> <alpine.DEB.1.10.0901150524340.716@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Jan 2009, Steven Rostedt wrote:

> 
> Ingo, revert this patch (or don't pull it yet)
> I just noticed that it does not compile. I should not be doing git pulls 
> at night :-(

Probably explains why I did not push it. I think I noticed it last night, 
but sent out the email by mistake. I was too tired to fix it up.

-- Steve
