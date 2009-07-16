Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbZGPDDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbZGPDDs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 23:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757230AbZGPDDs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 23:03:48 -0400
Received: from kroah.org ([198.145.64.141]:60738 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757165AbZGPDDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 23:03:47 -0400
Date: Wed, 15 Jul 2009 20:03:04 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: gregkh@suse.de, bigeasy@linuxtronix.de, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Bryan Wu <cooloney@kernel.org>
Subject: Re: [PATCH] USB: isp1760: allow platform devices to customize
 devflags
Message-ID: <20090716030304.GA30650@kroah.com>
References: <1245763114-7753-1-git-send-email-vapier@gentoo.org>
 <8bd0f97a0907150908y333f89eav1d0edbb6a5951c05@mail.gmail.com>
 <20090716021737.GA30363@kroah.com>
 <8bd0f97a0907151929t3ca67bc9gd4ebeae1e17894b0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8bd0f97a0907151929t3ca67bc9gd4ebeae1e17894b0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 10:29:40PM -0400, Mike Frysinger wrote:
> On Wed, Jul 15, 2009 at 22:17, Greg KH wrote:
> > On Wed, Jul 15, 2009 at 12:08:31PM -0400, Mike Frysinger wrote:
> >> On Tue, Jun 23, 2009 at 09:18, Mike Frysinger wrote:
> >> > From: Michael Hennerich <michael.hennerich@analog.com>
> >> >
> >> > Platform device support was merged earlier, but support for boards to
> >> > customize the devflags aspect of the controller was not.  We want this on
> >> > Blackfin systems to control the bus width, but might as well expose all of
> >> > the fields while we're at it.
> >>
> >> ping ...
> >
> > Ping who, yourself?
> 
> ping the guy who can merge the patch ...

Care to resend the whole thing?  It doesn't seem to be in my queue
anymore :(

thanks,

greg k-h
