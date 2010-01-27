Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357Ab0A0HKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357Ab0A0HKE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 02:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329Ab0A0HKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 02:10:00 -0500
Received: from ernst.netinsight.se ([194.16.221.21]:51465 "HELO
	ernst.netinsight.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754302Ab0A0HKA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 02:10:00 -0500
Date: Wed, 27 Jan 2010 08:09:50 +0100
From: Simon Kagstrom <simon.kagstrom@netinsight.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Provide ways of crashing the kernel through debugfs
Message-ID: <20100127080950.15685695@marrow.netinsight.se>
In-Reply-To: <2375c9f91001261853t1158a66aw86546a61e613338f@mail.gmail.com>
References: <20100126105640.6bf9488c@marrow.netinsight.se>
	<2375c9f91001260208t31379702tb49cb57d12d5890b@mail.gmail.com>
	<20100126111853.10890fc6@marrow.netinsight.se>
	<2375c9f91001261853t1158a66aw86546a61e613338f@mail.gmail.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010 10:53:23 +0800
Américo Wang <xiyou.wangcong@gmail.com> wrote:

> >> Hey, we already have /proc/sysrq-trigger, you need to state why
> >> it is better than using /proc/sysrq-trigger.
> >
> > Well, it provides a few more ways of crashing the kernel. That's
> > basically the only additional feature you'll get.
> 
> Yeah, I can see that, but why do I need to care how I crash the kernel
> as long as I can crash it in a way.

I understand what you mean, and I'm fine if this doesn't get merged.

Thanks for the comments!

// Simon
