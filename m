Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbZF2Swp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbZF2Swp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbZF2Swi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:52:38 -0400
Received: from kroah.org ([198.145.64.141]:40158 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689AbZF2Swi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:52:38 -0400
Date: Mon, 29 Jun 2009 11:52:29 -0700
From: Greg KH <greg@kroah.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Pavel Machek <pavel@ucw.cz>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       Brian Swetland <swetland@google.com>
Subject: Re: HTC Dream camera support for staging
Message-ID: <20090629185229.GA19305@kroah.com>
References: <20090629114339.GA25552@elf.ucw.cz> <Pine.LNX.4.64.0906292027130.4500@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0906292027130.4500@axis700.grange>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 08:28:33PM +0200, Guennadi Liakhovetski wrote:
> On Mon, 29 Jun 2009, Pavel Machek wrote:
> 
> > 
> > This patch adds driver for HTC Dream camera. I guess driver is
> > slightly higher quality than usual for staging/ , but it is fairly big
> > and I don't feel like doing all the cleanups myself. Also some parts
> > can probably be removed, as they did not end up in shipping hardware..
> > 
> > The driver is actually so big that I'll attach it gzipped, otherwise
> > it would not pass maillist limits.
> 
> when this patch will be leaving the "staging" state, it will have to be 
> converted to use v4l2-subdev API and submitted to linux-media.

Sounds reasonable.  All staging patches are submitted to the respective
subsystems for inclusion in order to move out of them.  So that's
nothing new.

thanks,

greg k-h
