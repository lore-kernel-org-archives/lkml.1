Return-Path: <linux-kernel-owner+w=401wt.eu-S1751503AbZJWEbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbZJWEbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 00:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZJWEbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 00:31:37 -0400
Received: from kroah.org ([198.145.64.141]:45482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbZJWEbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 00:31:34 -0400
Date: Thu, 22 Oct 2009 21:29:06 -0700
From: Greg KH <greg@kroah.com>
To: David Rientjes <rientjes@google.com>
Cc: Alex Chiang <achiang@hp.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] Documentation: document /sys/devices/system/cpu/
Message-ID: <20091023042906.GC26358@kroah.com>
References: <20091022033506.13399.90799.stgit@bob.kio> <alpine.DEB.2.00.0910220138380.9591@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0910220138380.9591@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 01:42:34AM -0700, David Rientjes wrote:
> On Wed, 21 Oct 2009, Alex Chiang wrote:
> 
> > Hi Greg, Randy,
> > 
> > Not sure who actually maintains Documentation/ABI/; if it's not either of
> > y'all then please point me at the correct maintainer.
> > 
> > Anyhow, I was proposing some patches to enhance the NUMA sysfs interface:
> > 
> > 	http://thread.gmane.org/gmane.linux.kernel.mm/40084/
> > 
> > I documented my changes, but David Rientjes suggested that I take this
> > as an opportunity to do a more thorough job, so here is an attempt at
> > doing so by documenting at least the files that I saw on my system. Maybe
> > there are more that I didn't configure in, but I think this series covers
> > a good amount.
> > 
> 
> Fantastic, thanks Alex!
> 
> One thing I noticed in patches 3-6 of this series is you've attached 
> multiple files to a single "What:" line.  That hasn't been done before 
> (ignore the style violations of sysfs-firmware-*) and I think it would be 
> better to seperate each file out into its own section.
> 
> I know it's long, but I think some automated scripts are eventually going 
> to use this documentation and it's best to follow the guidelines in 
> Documentation/ABI/README.

They are?  I don't know of any such scripts anywhere, do you?

thanks,

greg k-h
