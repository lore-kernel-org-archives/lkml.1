Return-Path: <linux-kernel-owner+w=401wt.eu-S1752404AbZGTRrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404AbZGTRrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 13:47:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751219AbZGTRry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 13:47:54 -0400
Received: from cantor.suse.de ([195.135.220.2]:47108 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbZGTRrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 13:47:53 -0400
Date: Mon, 20 Jul 2009 10:36:33 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Jones <davej@redhat.com>, Matthias Urlichs <smurf@smurf.noris.de>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       virtualization@lists.osdl.org, Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090720173633.GB25406@suse.de>
References: <20090720160025.GA20249@kroah.com>
 <20090720162810.GA22102@kroah.com>
 <20090720165941.GA15660@redhat.com>
 <20090720170911.GS12833@kiste.smurf.noris.de>
 <20090720171523.GA16129@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720171523.GA16129@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 01:15:23PM -0400, Dave Jones wrote:
> On Mon, Jul 20, 2009 at 07:09:11PM +0200, Matthias Urlichs wrote:
>  > Hi,
>  > 
>  > Dave Jones:
>  > > Given the numerous cleanup patches that already exist, is there any reason
>  > > to not just post the cleaned up drivers ?  It would certainly be more
>  > > reviewable than the current pile.
>  > > 
>  > Feel free to apply / combinediff these patches before reviewing. :-P
>  > 
>  > Personally, I don't want to ever see another patch where substantial
>  > changes (for some nontrivial value of "substantial") are intermixed
>  > with distracting s/\<BOOLEAN\>/bool/g cleanups.
> 
> 'Substantial changes' doesn't matter when it's an initial submission.
> By its nature, it's a substantial change.

Note, to keep the proper authorship information, for a lot of drivers in
the staging tree, we commit the original driver with the correct Author:
and signed-off-by lines, and then we do cleanups after that to properly
attribute the developers doing that work.

thanks,

greg k-h
