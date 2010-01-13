Return-Path: <linux-kernel-owner+w=401wt.eu-S1754004Ab0AMAVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab0AMAVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 19:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326Ab0AMAVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 19:21:17 -0500
Received: from kroah.org ([198.145.64.141]:56544 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131Ab0AMAVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 19:21:16 -0500
Date: Tue, 12 Jan 2010 16:17:24 -0800
From: Greg KH <greg@kroah.com>
To: Scott Smedley <ss@aao.gov.au>
Cc: Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Yet another dt3155 driver for drivers/staging
Message-ID: <20100113001724.GB29904@kroah.com>
References: <201001122242.22774.mitov@issp.bas.bg>
 <20100112235221.GA20761@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100112235221.GA20761@aao.gov.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 10:52:21AM +1100, Scott Smedley wrote:
> Hi Marin,
> 
> > dt3155 frame grabber I am using in my experiments since 
> > the time of 2.6.17 kernel.
> 
> Whoah!
> 
> > I will really appreciate your comments, suggestions, criticism.
> 
> I haven't tried your driver but the code looks much neater than
> our driver. Still, I am wondering why you chose to implement a
> device driver from scratch, rather than use an existing one?
> 
> http://sourceforge.net/projects/dt3155a/
> 
> I'll leave decisions about whether to merge or discard (either
> driver) to Greg. My 2 cents is that there should only be 1 DT3155
> driver for users to choose from.

I agree, we only need one of them.

Scott, any comparison between the two of them as to which one actually
works better?

thanks,

greg k-h
