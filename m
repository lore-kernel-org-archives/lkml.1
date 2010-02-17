Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab0BQVKk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 16:10:40 -0500
Received: from kroah.org ([198.145.64.141]:55645 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468Ab0BQVKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 16:10:38 -0500
Date: Wed, 17 Feb 2010 12:46:39 -0800
From: Greg KH <greg@kroah.com>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: David Miller <davem@davemloft.net>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, 12o3l@tiscali.nl,
       rmk+kernel@arm.linux.org.uk, netdev@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 9/9] net: move am79c961's probe function to
 .devinit.text
Message-ID: <20100217204639.GC5674@kroah.com>
References: <20100203150850.GA28815@kroah.com>
 <1265313417-5568-9-git-send-email-u.kleine-koenig@pengutronix.de>
 <20100204.120501.110961896.davem@davemloft.net>
 <20100204200638.GA3035@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100204200638.GA3035@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 04, 2010 at 09:06:38PM +0100, Uwe Kleine-König wrote:
> On Thu, Feb 04, 2010 at 12:05:01PM -0800, David Miller wrote:
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > Date: Thu,  4 Feb 2010 20:56:57 +0100
> > 
> > > @David Miller: this patch is in patchwork with State: Not Applicable.
> > > Does that mean that netdev isn't the right tree for this patch?
> > 
> > I was under the impression that someone would pick up the
> > whole set as a unit.
> Ah, OK.  I hope Greg does exactly that now.

I have now done this.

thanks,

greg k-h
