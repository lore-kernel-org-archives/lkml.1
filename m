Return-Path: <linux-kernel-owner+w=401wt.eu-S932633AbZHNQ0F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbZHNQ0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 12:26:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755950AbZHNQ0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 12:26:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916AbZHNQ0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 12:26:04 -0400
Date: Fri, 14 Aug 2009 09:15:23 -0700
From: Greg KH <gregkh@suse.de>
To: Ozan =?utf-8?B?w4dhxJ9sYXlhbg==?= <ozan@pardus.org.tr>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/74] 2.6.30.5-stable review
Message-ID: <20090814161523.GA11228@suse.de>
References: <20090813195705.GA22393@kroah.com>
 <4A850395.4050204@pardus.org.tr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4A850395.4050204@pardus.org.tr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 09:26:29AM +0300, Ozan Çağlayan wrote:
> Greg KH wrote On 13-08-2009 22:57:
> > This is the start of the stable review cycle for the 2.6.30.5 release.
> > There are 74 patches in this series, all will be posted as a response to
> > this one.  If anyone has any issues with these being applied, please let
> > us know.  If anyone is a maintainer of the proper subsystem, and wants
> > to add a Signed-off-by: line to the patch, please respond with it.
> >
> > These patches are sent out with a number of different people on the Cc:
> > line.  If you wish to be a reviewer, please email stable@kernel.org to
> > add your name to the list.  If you want to be off the reviewer list,
> > also email us.
> >
> > Responses should be made by Saturday, August 15, 2009 19:00:00 UTC.
> > Anything received after that time might be too late.
> >   
> 
> Hi,
> 
> According to the stable_kernel_rules document, new device IDs and quirks
> should also be accepted.

That is true.

> I wonder if it's possible to cherry-pick new device additions to
> usb-serial modem drivers (HSDPA stuff) for further releases?

Sure, send me the git commit ids that you want added please.

> And also there was this one that may be included in .5:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=0083fc2c50e6c5127c2802ad323adf8143ab7856

Ok, I'll queue it up for the next release.

thanks,

greg k-h
