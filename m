Return-Path: <linux-kernel-owner+w=401wt.eu-S1755872Ab0A1BXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab0A1BXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 20:23:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841Ab0A1BXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 20:23:54 -0500
Received: from kroah.org ([198.145.64.141]:46848 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753307Ab0A1BXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 20:23:53 -0500
Date: Wed, 27 Jan 2010 17:11:38 -0800
From: Greg KH <greg@kroah.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Vikram Dhillon <opensolarisdev@gmail.com>,
       linux-arm-kernel@lists.infradead.org, Eric Miao <eric.miao@marvell.com>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH] RFC: make struct platform_driver.id_table const
Message-ID: <20100128011135.GA24068@kroah.com>
References: <1264179837-22999-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20100125013421.GL26562@trinity.fluff.org>
 <4B5CFEBE.2070906@gmail.com>
 <20100125074242.GA12480@pengutronix.de>
 <4B5E092B.3070801@gmail.com>
 <f17812d71001252201n215f2a9y1906fef630726dbe@mail.gmail.com>
 <20100126083500.GA20792@pengutronix.de>
 <f17812d71001260054g57b282c4n90977cc76d521f89@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f17812d71001260054g57b282c4n90977cc76d521f89@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 04:54:13PM +0800, Eric Miao wrote:
> 2010/1/26 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:
> > Greg,
> >
> > On Tue, Jan 26, 2010 at 02:01:15PM +0800, Eric Miao wrote:
> >> I seems to remember a similar patch sent to GregKH weeks ago and
> >> should be sitting somewhere but this one looks to be more complete.
> > Yes, it's
> >        gregkh-2.6/gregkh-05-driver-core/driver-core-make-platform_device_id-table-const.patch
> >
> > Below you can find the current state with all Acks it has got until now.
> > (Eric: I considered your mail as Ack, too.  OK?)
> 
> OK.
> 
> > As I don't know how to change the log message with an incremental patch
> > you have to tell me if you prefer this way.
> 
> Greg?

I took out the chunk that came in the previous patch, and applied it.

thanks,

greg k-h
