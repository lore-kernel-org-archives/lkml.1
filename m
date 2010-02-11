Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0BKWm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 17:42:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60195 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757301Ab0BKWm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 17:42:57 -0500
Date: Thu, 11 Feb 2010 14:42:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alessandro Zummo <a.zummo@towertech.it>
Cc: rtc-linux@googlegroups.com, u.kleine-koenig@pengutronix.de,
       Paul Gortmaker <p_gortmaker@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [rtc-linux] [PATCH RESEND] rtc/hctosys: only claim the RTC
 provided  the system time if it did
Message-Id: <20100211144240.8fbec55e.akpm@linux-foundation.org>
In-Reply-To: <20100211115700.12853990@linux.lan.towertech.it>
References: <1265663419-10165-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1265885549-23920-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<20100211115700.12853990@linux.lan.towertech.it>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Feb 2010 11:57:00 +0100
Alessandro Zummo <a.zummo@towertech.it> wrote:

> On Thu, 11 Feb 2010 11:52:29 +0100
> Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de> wrote:
> 
> 
> > Signed-off-by: Uwe Kleine-K__nig <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> > 
> > this time the patch is complete.
> > 
> > What do you think about it?

I do dislike having to trawl through the patch trying to work out what
the changelog forgot to tell me.

What problem is being fixed here?

What is the user-observable manifestation of that problem?

How does the patch fix it?

Stuff like that!

>  looks nice but I'll have to give a deeper look.
>  will probably queue for the next merge window

I merged it with a "needs Alessandro ack" note-to-self.
