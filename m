Return-Path: <linux-kernel-owner+w=401wt.eu-S1763227AbYARQht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763227AbYARQht (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 11:37:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761924AbYARQhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 11:37:41 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:57406 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761808AbYARQhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 11:37:40 -0500
Date: Fri, 18 Jan 2008 11:37:15 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: linux@sundmangroup.com
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: SCHED_FIFO & system()
In-Reply-To: <37593.147.11.3.128.1200565147.squirrel@www.sundmangroup.com>
Message-ID: <Pine.LNX.4.58.0801181135380.7574@gandalf.stny.rr.com>
References: <37593.147.11.3.128.1200565147.squirrel@www.sundmangroup.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 17 Jan 2008 linux@sundmangroup.com wrote:
> time kernel thread does not get scheduled.
>
> The thread that calls system("run_my_script") is configured as SCHED_OTHER.
>
> The Kernel is 2.6.21.

Could you try the latest kernel, and if that still gives you problems, try
out Ingo's sched-devel (from what Gregory Haskins posted).

Let us know how it turns out.

Thanks,

-- Steve


>
>
> Anybody who recognize this or similar situations?
>
>
