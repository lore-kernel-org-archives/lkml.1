Return-Path: <linux-kernel-owner+w=401wt.eu-S1753615AbYH0Rcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753615AbYH0Rcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 13:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYH0Rc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 13:32:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57888 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbYH0RcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 13:32:25 -0400
Date: Wed, 27 Aug 2008 10:21:23 -0700
From: Greg KH <greg@kroah.com>
To: Marcel Janssen <korgull@home.nl>
Cc: linux-usb@vger.kernel.org, Stefan Kopp <stefan_kopp@agilent.com>,
       Felipe Balbi <me@felipebalbi.com>, linux-kernel@vger.kernel.org,
       Marcel Janssen <marcel.janssen@admesy.nl>
Subject: Re: [PATCH] USB: add USB test and measurement class driver
Message-ID: <20080827172123.GA18822@kroah.com>
References: <20080827000501.GA29570@kroah.com> <200808270822.59859.korgull@home.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808270822.59859.korgull@home.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 08:22:58AM +0200, Marcel Janssen wrote:
> Hello Greg,
> 
> On Wednesday 27 August 2008 02:05:01 Greg KH wrote:
> > The autosuspend support isn't that hard either, but I would like to find
> > someone with one of these devices to help me in testing that before I
> > add it, so I imagine the driver can go into the tree without that being
> > added at this time.
> 
> I think I can be of some help here. We have usbtmc devices that have this 
> functionality included. The only difficulty I currently have is time. I'll be 
> on a business trip for the next 3 weeks but have our units with me and may be 
> able to test it.

That's great.  How about a basic "the driver works or not" type testing
of what we have already?

After that, we can work on autosuspend support.

thanks,

greg k-h
