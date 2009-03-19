Return-Path: <linux-kernel-owner+w=401wt.eu-S1758333AbZCSQ21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333AbZCSQ21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 12:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758435AbZCSQ2B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 12:28:01 -0400
Received: from kroah.org ([198.145.64.141]:38994 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754972AbZCSQ2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 12:28:00 -0400
Date: Thu, 19 Mar 2009 09:27:19 -0700
From: Greg KH <greg@kroah.com>
To: Sindhudweep Sarkar <sindhudweep.sarkar@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Thomas Hellstrom <thellstrom@vmware.com>,
       Richard Purdie <rpurdie@linux.intel.com>
Subject: Re: [patch 0/5] Intel Poulsbo/Morrestown DRM driver and DRM core
	changes
Message-ID: <20090319162719.GB32078@kroah.com>
References: <20090319040809.GA29249@kroah.com> <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c046ab30903190903r298a0334n939e64403b8aeda6@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 19, 2009 at 12:03:09PM -0400, Sindhudweep Sarkar wrote:
> This might be the opinion of a completely non educated end user but it
> seems that an intel specific drm and other bits (xorg, mesa) would be
> somewhat of a maintenance waste.

What do you mean by this?

> TI-OMAP 3xxx and a couple of other arm processors use similar SGX-5xx
> graphics cores. IIRC arm is often little endian so perhaps a unified
> driver would be easier in the long term.

Long term lots of things are good.

But how do I get my laptop that I currently have right now up and
running properly with linux in a better-than-800x600-framebuffer mode?

That's why I need/want this driver now, there are hundreds of thousands
of these types of laptops in the pipeline to users and I want them to
run Linux, not be forced to run some other operating system...

thanks,

greg k-h
