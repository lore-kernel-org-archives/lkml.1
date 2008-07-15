Return-Path: <linux-kernel-owner+w=401wt.eu-S1758192AbYGODBh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192AbYGODBh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 23:01:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYGODB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 23:01:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59245 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809AbYGODB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 23:01:29 -0400
Date: Mon, 14 Jul 2008 23:01:27 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
cc: Gregory Haskins <ghaskins@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [sched-devel, patch-rfc] rework #2 of "prioritize non-migratable
 tasks over migratable ones"
In-Reply-To: <b647ffbd0807140750r54e5139aj7b25a28ef7ca247e@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0807142301000.4530@gandalf.stny.rr.com>
References: <1214947935.5658.11.camel@earth>
 <b647ffbd0807140750r54e5139aj7b25a28ef7ca247e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 14 Jul 2008, Dmitry Adamushko wrote:

>
> 2008/7/1 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> >
> > Finally, this new version compiles and boots (applied a minor compilation fix).
> > Functionality is not yet fully tested though.
> >
> > It's on top of today's tip tree.
> >
> > Any objections to this approach?
>
> [ ping ]
>
> Gregory or anyone else, any feedback on this one?
>

A quick look at this, looks fine with me.

-- Steve

