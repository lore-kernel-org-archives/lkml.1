Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYIZURR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYIZURR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 16:17:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752503AbYIZURD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 16:17:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36446 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbYIZURB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 16:17:01 -0400
Date: Fri, 26 Sep 2008 13:09:35 -0700
From: Greg KH <greg@kroah.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org, =?utf-8?B?UGF3ZcWC?= Sikora <pluto@agmk.net>
Subject: Re: [kernel-abi] symbol versioning vs. out-of-tree modules.
Message-ID: <20080926200935.GB2460@kroah.com>
References: <Y165ES5i.1222268879.9618400.pluto@agmk.net> <48DCC691.30205@imap.cc> <20080926153634.GD21528@kroah.com> <200809261919.52382.a.miskiewicz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809261919.52382.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 07:19:52PM +0200, Arkadiusz Miskiewicz wrote:
> On Friday 26 September 2008, Greg KH wrote:
> > On Fri, Sep 26, 2008 at 01:25:05PM +0200, Tilman Schmidt wrote:
> [...]
> > > - http://acx100.sourceforge.net/
> >
> > I think this one has some dubious legal issues involved, and I can't
> > take it at this time :(
> 
> Is this only about drivers? What about for example apparmor?

apparmor requires patches to core parts of the kernel in order for it to
work.  This is for stand-alone drivers/filesystems/whatever only.

thanks,

greg k-h
