Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbZCSTUs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbZCSTUs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 15:20:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754463AbZCSTUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 15:20:37 -0400
Received: from kroah.org ([198.145.64.141]:52207 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751756AbZCSTUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 15:20:37 -0400
Date: Thu, 19 Mar 2009 12:20:31 -0700
From: Greg KH <greg@kroah.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>,
       David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090319192031.GA16776@kroah.com>
References: <20090319040809.GA29249@kroah.com> <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com> <20090319162719.GB32078@kroah.com> <20090319185338.GA21890@srcf.ucam.org> <20090319190254.GA31771@kroah.com> <20090319190530.GA22248@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319190530.GA22248@srcf.ucam.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 07:05:30PM +0000, Matthew Garrett wrote:
> On Thu, Mar 19, 2009 at 12:02:54PM -0700, Greg KH wrote:
> > On Thu, Mar 19, 2009 at 06:53:38PM +0000, Matthew Garrett wrote:
> > > On Thu, Mar 19, 2009 at 09:27:19AM -0700, Greg KH wrote:
> > > 
> > > > But how do I get my laptop that I currently have right now up and
> > > > running properly with linux in a better-than-800x600-framebuffer mode?
> > > 
> > > You don't, because there's no working X driver.
> > 
> > Um, no, I have one right here, seems to work ok.  Richard pointed out
> > the public git tree for it.
> 
> With current X? If that's been fixed up recently then it's a definite 
> improvement, but last I checked it only built against old X servers.

It currently only builds with new X servers, which turned out to be a
problem trying to get it to work on an openSUSE 11.1 machine, which uses
an older xserver, but that's a distro issue, not an upstream issue...

thanks,

greg k-h
