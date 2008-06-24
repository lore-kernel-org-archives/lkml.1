Return-Path: <linux-kernel-owner+w=401wt.eu-S1755355AbYFXBbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755355AbYFXBbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 21:31:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbYFXBaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 21:30:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60331 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbYFXBav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 21:30:51 -0400
Date: Mon, 23 Jun 2008 21:30:48 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: ciaby <ciaby@autistici.org>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] 2.6.25.4-rt6: missing =?UTF-8?Q?global=5Frt=5Fruntime=28=29=20in?=
 =?UTF-8?Q?=20sched=2Ec?=
In-Reply-To: <Pine.LNX.4.58.0806231843120.27994@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0806232129400.8540@gandalf.stny.rr.com>
References: <7688fdc041a8f848b0627dccccddcf12@localhost>
 <Pine.LNX.4.58.0806231843120.27994@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Jun 2008, Steven Rostedt wrote:

>
> On Mon, 9 Jun 2008, ciaby wrote:
>
> >
> >
> > I already sent this patch, but seems that nobody cared... the last 2
> > revisions of the -rt kernel don't compile properly.
> > Second patch to fix this.
> > Regards
>
> I still don't have a "Signed-off-by:" for this patch. Please send it to me
> ASAP, otherwise it will miss the next release.
>

I'm posting out -rt7 now without this patch. I'm hoping to get your
Signed-off-by for -rt8 which will come out soon (I want to get Gregory's
patches testest ASAP too).

-- Steve

