Return-Path: <linux-kernel-owner+w=401wt.eu-S1756708AbZBKXVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708AbZBKXVl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 18:21:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbZBKXVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 18:21:33 -0500
Received: from mailserv59-us.natinst.com ([130.164.14.243]:2726 "EHLO
	mailserv59-us.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbZBKXVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 18:21:32 -0500
Date: Wed, 11 Feb 2009 17:17:28 -0600
From: Shawn Bohrer <shawn.bohrer@ni.com>
To: fmhess@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de, abbotti@mev.co.uk,
       ds@schleef.org
Subject: Re: [staging] High level Comedi feedback
Message-ID: <20090211231728.GC23561@bohrers.amer.corp.natinst.com>
References: <20090209180144.GD18058@bohrers.amer.corp.natinst.com> <200902092238.49109.fmhess@speakeasy.net>
MIME-Version: 1.0
In-Reply-To: <200902092238.49109.fmhess@speakeasy.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-MIMETrack: Itemize by SMTP Server on MailServ59-US/AUS/H/NIC(Release 8.0.2|August 07, 2008) at
 02/11/2009 05:20:55 PM,
	Serialize by Router on MailServ59-US/AUS/H/NIC(Release 8.0.2|August 07, 2008) at
 02/11/2009 05:20:57 PM,
	Serialize complete at 02/11/2009 05:20:57 PM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Frank,

On Mon, Feb 09, 2009 at 10:38:44PM -0500, Frank Mori Hess wrote:
> On Monday 09 February 2009 13:01, Shawn Bohrer wrote:
> > 6. COMEDI doesn't yet support configuring hardware buffer sizes for deep
> > on-board FIFOs.
>
> There is INSN_CONFIG_BLOCK_SIZE, which a couple drivers use to configure
> their hardware fifo size.

Thanks I'll take a close look at this.

> By the way, I'm not subscribed to linux-kernel.  Comedi does have its own
> mailing list, maybe this kind of discussion would be easier on a more
> specific, lower traffic list?

Since Comedi is working its way into the kernel I'd like to get a
little broader exposure on some of the things that we'd like to see
improved before any interfaces get set in stone.  I think it could be
beneficial to cc the Comedi list, but it looks like that list only
accepts emails from subscribers.

--
Shawn
