Return-Path: <linux-kernel-owner+w=401wt.eu-S933191AbXHXSfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933191AbXHXSfY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 14:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762157AbXHXSfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 14:35:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60518 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762025AbXHXSfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 14:35:11 -0400
Date: Fri, 24 Aug 2007 11:33:49 -0700
From: Greg KH <greg@kroah.com>
To: Bodo Eggert <7eggert@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Matt Colyer <matt@colyer.name>, jeffm@suse.de
Subject: Re: [linux-usb-devel] [RFC] USB: driver for iphone charging
Message-ID: <20070824183349.GA14855@kroah.com>
References: <8VtFd-7mx-51@gated-at.bofh.it> <E1IOWl6-0000iK-5t@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1IOWl6-0000iK-5t@be1.lrz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 12:51:19PM +0200, Bodo Eggert wrote:
> Greg KH <greg@kroah.com> wrote:
> 
> > my berry_charge code that adds support for charging the iphone when it
> > is plugged into a Linux machine.
> 
> This should be a runtime option, because you may want to build a non-module
> kernel and not charge the phone while running your laptop on battery.

Then just don't build this module if you are creating such a kernel :)

Same thing goes for the existing blackberry charge driver too...

thanks,

greg k-h
