Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706Ab0BCPJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 10:09:37 -0500
Received: from kroah.org ([198.145.64.141]:58523 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756501Ab0BCPJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 10:09:34 -0500
Date: Wed, 3 Feb 2010 07:08:50 -0800
From: Greg KH <greg@kroah.com>
To: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform_driver_register:  warn if probe is in
	.init.text
Message-ID: <20100203150850.GA28815@kroah.com>
References: <20090629075535.GA20155@pengutronix.de> <20090711033459.GC1344@suse.de> <20090711100014.GA9540@pengutronix.de> <20090711170548.GC5205@suse.de> <20090907141941.GA19380@pengutronix.de> <20100122170641.GD13718@pengutronix.de> <20100122173846.GA11057@suse.de> <20100126085928.GD20792@pengutronix.de> <20100128180235.GE19871@kroah.com> <20100203094226.GD11354@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100203094226.GD11354@pengutronix.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 03, 2010 at 10:42:26AM +0100, Uwe Kleine-K?nig wrote:
> Hello,
> 
> > > So can you please look into that before they are swapped out of your
> > > inbox the third(?) time?
> > 
> > I think the video ones can be all in one patch, that makes it easier for
> > me to track and apply.  Same goes for any others you can merge together.
> So I group by drivers/* and arch/*?

Sure, that would make it easier, right?

thanks,

greg k-h
