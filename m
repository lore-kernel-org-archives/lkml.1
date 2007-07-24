Return-Path: <linux-kernel-owner+w=401wt.eu-S1763254AbXGXSM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763254AbXGXSM4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 14:12:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbXGXSMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 14:12:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52875 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758188AbXGXSMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 14:12:45 -0400
Date: Tue, 24 Jul 2007 11:12:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org,
       "Greg Ungerer" <gerg@snapgear.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "Paul Mundt" <lethal@linux-sh.org>, "Tim Bird" <tim.bird@am.sony.com>,
       bryan.wu@analog.com
Subject: Re: early_printk accessing __log_buf
Message-Id: <20070724111215.8d91dc7c.akpm@linux-foundation.org>
In-Reply-To: <200707241350.45086.rgetz@blackfin.uclinux.org>
References: <200707181756.44074.rgetz@blackfin.uclinux.org>
	<200707231815.38124.rgetz@blackfin.uclinux.org>
	<20070723153437.4fc62253.akpm@linux-foundation.org>
	<200707241350.45086.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007 13:50:44 -0400
Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> > Lots of the kernel is pretty crappy.  One of our main tools for fixing
> > that is to ensure that new stuff is non-crappy.
> 
> No problem - I wasn't advocating putting something that you thought was crappy 
> into your tree (afterall that would be futile).

You wouldn't be the first ;)

> Other than making the 
> overhead high - is there a way to make it less crappy?
> 
> If the answer is no, and Mike's latest suggestion/patch is OK - that is what I 
> will live with - and tell people to spend more on their power supply.

Oh well, it sounds like we need the super-duper fast version.  Keep it as
simple as possible, please.

