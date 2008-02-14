Return-Path: <linux-kernel-owner+w=401wt.eu-S1760556AbYBNS3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760556AbYBNS3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754617AbYBNS3D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:29:03 -0500
Received: from verein.lst.de ([213.95.11.210]:44360 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754019AbYBNS3B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:29:01 -0500
Date: Thu, 14 Feb 2008 19:26:53 +0100
From: Christoph Hellwig <hch@lst.de>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Bill Davidsen <davidsen@tmr.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
Message-ID: <20080214182653.GA6456@lst.de>
References: <1201829922.23523.68.camel@brick> <47B3AC24.5050605@tmr.com> <20080213185502.0005dd4d@extreme> <47B48564.1010709@tmr.com> <47B4876B.6020100@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B4876B.6020100@linux.intel.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 10:24:43AM -0800, Arjan van de Ven wrote:
> Bill Davidsen wrote:
> >Note that because the hardware is old, it's highly likely that most of 
> >it will be retired before that sk98lin driver needs a change. I can't 
> >see anyone using sk98lin on a new system, so it would be less 
> >contentious to let the hardware (or users) die of natural causes if you 
> >can.
> >
> 
> the problem is that the new one DOES NOT GET FIXED.
> THAT is a huge problem; it means we have a buggy driver...

It's also utterly missing the point.  The skge driver supports all the
hardware that sk98lin supports.  If it doesn't work bug Stephen who's
a very responsive maintainer.
