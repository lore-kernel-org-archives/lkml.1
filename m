Return-Path: <linux-kernel-owner+w=401wt.eu-S1754783AbZCTOzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783AbZCTOzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 10:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbZCTOzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 10:55:09 -0400
Received: from kroah.org ([198.145.64.141]:51597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751974AbZCTOzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 10:55:08 -0400
Date: Fri, 20 Mar 2009 07:53:40 -0700
From: Greg KH <greg@kroah.com>
To: Daniel Stone <daniel@fooishbar.org>,
       Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>,
       David Airlie <airlied@linux.ie>,
       Thomas Hellstrom <thellstrom@vmware.com>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090320145340.GA11347@kroah.com>
References: <20090319040809.GA29249@kroah.com> <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com> <20090319162719.GB32078@kroah.com> <20090320060823.GF32194@fooishbar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320060823.GF32194@fooishbar.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 05:08:23PM +1100, Daniel Stone wrote:
> Greg,
> 
> On Thu, Mar 19, 2009 at 09:27:19AM -0700, Greg KH wrote:
> > On Thu, Mar 19, 2009 at 12:03:09PM -0400, Sindhudweep Sarkar wrote:
> > > TI-OMAP 3xxx and a couple of other arm processors use similar SGX-5xx
> > > graphics cores. IIRC arm is often little endian so perhaps a unified
> > > driver would be easier in the long term.
> > 
> > Long term lots of things are good.
> > 
> > But how do I get my laptop that I currently have right now up and
> > running properly with linux in a better-than-800x600-framebuffer mode?
> > 
> > That's why I need/want this driver now, there are hundreds of thousands
> > of these types of laptops in the pipeline to users and I want them to
> > run Linux, not be forced to run some other operating system...
> 
> By the same logic, would you support including the proprietary NVIDIA
> driver while we wait for Nouveau to catch up?

The license of the NVIDIA driver does not allow that to even be a
possibility.

thanks,

greg k-h
