Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0BLMBZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 07:01:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756701Ab0BLMBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:01:21 -0500
Date: Fri, 12 Feb 2010 13:01:20 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Oliver Neukum <oliver@neukum.org>
Cc: David Fries <david@fries.net>, USB list <linux-usb@vger.kernel.org>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbhid control queue full, due to stuck control request
In-Reply-To: <201002121259.08146.oliver@neukum.org>
Message-ID: <alpine.LNX.2.00.1002121301110.30967@pobox.suse.cz>
References: <20100206172051.GA22311@spacedout.fries.net> <201002120835.36908.oliver@neukum.org> <alpine.LNX.2.00.1002121256500.30967@pobox.suse.cz> <201002121259.08146.oliver@neukum.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010, Oliver Neukum wrote:

> > > > Oliver Neukum, this is based on your patch, do you agree with the
> > > > changes?
> > > 
> > > I do agree.
> > 
> > Thanks a lot guys for tracking this down and fixing it. I have applied the 
> > patch.
> 
> This being a fix for broken hardware it should go into stable, too.
> Would you forward it?

Yes, will take care of that.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
