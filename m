Return-Path: <linux-kernel-owner+w=401wt.eu-S1753248AbYJAXn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbYJAXn1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2008 19:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbYJAXnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 19:43:19 -0400
Received: from kroah.org ([198.145.64.141]:40885 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750967AbYJAXnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 19:43:18 -0400
Date: Wed, 1 Oct 2008 16:26:34 -0700
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Chuck Ebbert <cebbert@redhat.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       stable@kernel.org
Subject: Re: [stable] Unfixed regressions in 2.6-stable
Message-ID: <20081001232634.GB31609@kroah.com>
References: <48C9A8C4.9080803@redhat.com> <Pine.LNX.4.64.0809121324260.20811@vixen.sonytel.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809121324260.20811@vixen.sonytel.be>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2008 at 01:26:07PM +0200, Geert Uytterhoeven wrote:
> On Thu, 11 Sep 2008, Chuck Ebbert wrote:
> > Description: Kernel hangs when booting on Sony PS3
> > Version(s):  2.6.25.12 - 2.6.25.17
> > Caused-by:
> > http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob_plain;f=releases/2.6.25.12/usb-fix-interrupt-disabling-for-hcds-with-shared-interrupt-handlers.patch;hb=HEAD
> > Version(s):  2.6.26 - 2.6.26.5
> > Caused-by:
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=de85422b94ddb23c021126815ea49414047c13dc
> > Patch:
> > http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob_plain;f=usb.current/usb-fix-hcd-interrupt-disabling.patch;hb=HEAD
> > Patch is not in mainline.
> 
> Greg, any chance we can get this in 2.6.27?

It's now in, and also added to the 2.6.25 and .26-stable queues.

thanks,

greg k-h
