Return-Path: <linux-kernel-owner+w=401wt.eu-S1757782AbZFLPYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782AbZFLPYg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbZFLPY2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:24:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58216 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751582AbZFLPY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:24:28 -0400
Date: Fri, 12 Jun 2009 16:25:29 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] scripts/checksyscalls.sh: only whine perf_counter_open
 when supported
Message-ID: <20090612162529.2fc4d863@lxorguk.ukuu.org.uk>
In-Reply-To: <20090612135603.GF32105@elte.hu>
References: <20090612120507.GH16044@elte.hu>
	<8bd0f97a0906120513u4e823460t8192f00fd0460ab@mail.gmail.com>
	<20090612121757.GD31845@elte.hu>
	<8bd0f97a0906120522v51ae0151i48d5f6846ddcff10@mail.gmail.com>
	<20090612123152.GE31845@elte.hu>
	<8bd0f97a0906120541x739b7902pe40ff7aa91337bac@mail.gmail.com>
	<20090612125941.GI31845@elte.hu>
	<8bd0f97a0906120604o1e90ac93l469e86173224364e@mail.gmail.com>
	<20090612130949.GJ31845@elte.hu>
	<8bd0f97a0906120621o609d7489v83cd3efc0102412d@mail.gmail.com>
	<20090612135603.GF32105@elte.hu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Fri, Jun 12, 2009 at 09:09, Ingo Molnar wrote:
> > > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> > >> On Fri, Jun 12, 2009 at 08:59, Ingo Molnar wrote:
> > >> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> > >> >> On Fri, Jun 12, 2009 at 08:31, Ingo Molnar wrote:
> > >> >> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> > >> >> >> On Fri, Jun 12, 2009 at 08:17, Ingo Molnar wrote:
> > >> >> >> > * Mike Frysinger <vapier.adi@gmail.com> wrote:
> > >> >> >> >> On Fri, Jun 12, 2009 at 08:05, Ingo Molnar wrote:
> > >> >> >> >> > * Mike Frysinger <vapier@gentoo.org> wrote:
>

> Anyway, i have no time to teach you about kernel mainteinance basics 
> really so i probably wont follow up on future emails.

So yet again you resort to personal attacks when someone objects to the
world according to Ingo. Please stop it, it's not as if you can't find
good technical reasons in many of these cases.

And please both of you - trim the emails you are replying to ..
