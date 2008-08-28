Return-Path: <linux-kernel-owner+w=401wt.eu-S1757299AbYH1XNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbYH1XNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 19:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbYH1XNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 19:13:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41070 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872AbYH1XNN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 19:13:13 -0400
Date: Thu, 28 Aug 2008 20:06:59 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: greg@kroah.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Brian Merrell <bgmerrell@novell.com>,
       Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>, gregkh@suse.de
Subject: Re: [patch 00/03] USB-IP patches
Message-ID: <20080828230659.GA9193@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	greg@kroah.com, linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org, Brian Merrell <bgmerrell@novell.com>,
	Takahiro Hirofuchi <hirofuchi@users.sourceforge.net>,
	gregkh@suse.de
References: <20080828230016.GA15014@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828230016.GA15014@kroah.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 28, 2008 at 04:00:16PM -0700, greg@kroah.com escreveu:
> Here's 3 patches that adds USB-IP functionality code to the kernel tree.
> 
> It is against 2.6.27-rc4, and has been added to the -staging tree.  If
> there are no major objections, I'll also queue it up in the usb tree for
> submission into 2.6.28.
> 
> The code is based on Takahiro's great work that has been sitting outside
> of the kernel for many many years now.  Brian Merrell took the most
> recent version of the code, cleaned it up and sent it to me.  I did more
> cleanup and split the patch into 3 pieces, making it a bit easier to
> work with.
> 
> There are still a number of checkpatch.pl warnings/errors emitted, and
> Brian said he would work on them in the upcoming weeks, but they don't
> distract from the basic functionality and a good review would be nice to
> have.
> 
> We do need some more documentation for how to use this code (you need
> the tools at usbip.sf.net), and how the sysfs files are exporting data
> to userspace.  Brian, can you write up the sysfs interface in the format
> that Documentation/ABI/ details and also provide some kind of basic
> HOWTO to include in the kernel source tree?

Great stuff, I almost worked on udp_hcd or something along these lines,
will definetely take a look! :-)

- Arnaldo
