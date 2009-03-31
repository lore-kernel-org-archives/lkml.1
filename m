Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbZCaIOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbZCaIOe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:14:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756526AbZCaIOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:14:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753471AbZCaIOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:14:14 -0400
Date: Tue, 31 Mar 2009 01:04:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>, avishay@gmail.com,
       jeff@garzik.org, linux-fsdevel@vger.kernel.org, osd-dev@open-osd.org,
       James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, linux-next@vger.kernel.org
Subject: Re: [PATCHSET 0/8 version 4] exofs for kernel 2.6.30
Message-Id: <20090331010408.fa43df98.akpm@linux-foundation.org>
In-Reply-To: <49D1C929.4070403@panasas.com>
References: <49C1331D.1080805@panasas.com>
	<20090330142200.af4b497c.akpm@linux-foundation.org>
	<49D1C44D.8060806@panasas.com>
	<49D1C929.4070403@panasas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 10:41:29 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:

> 
> I forgot to say. Some of the people that sent comments where:
>   Marcin Slusarz <marcin.slusarz@gmail.com>
>   Evgeniy Polyakov <zbr@ioremap.net>
>   Jeff Garzik <jeff@garzik.org>
>   Pavel Machek <pavel@suse.cz>
>   Benny Halevy <bhalevy@panasas.com>
>   Alan Cox <alan@lxorguk.ukuu.org.uk>
>   Andrew Morton <akpm@linux-foundation.org>
> 
> And then there was a long flame war about user-mode API, which I now
> have, and all in kernel utilities are gone.
> 
> To the best of my knowledge I have addressed all comments, at least
> no one complained.
> 

Let me take a quick look...

<quickly looks>

OK, I foud a few minor things, but the code looks fine to me.  However
I cannot speak to the overall design and to the actual desirability of
adding the feature to Linux.

I'd say that unless someone pipes up with a showstopper objection in
the next few days, please send the pull request to Linus near the end of
the week.
