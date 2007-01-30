Return-Path: <linux-kernel-owner+w=401wt.eu-S965604AbXA3P2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965604AbXA3P2D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 10:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965613AbXA3P2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 10:28:03 -0500
Received: from twin.jikos.cz ([213.151.79.26]:45552 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965604AbXA3P2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 10:28:01 -0500
Date: Tue, 30 Jan 2007 16:27:05 +0100 (CET)
From: Jiri Kosina <jikos@jikos.cz>
To: Soeren Sonnenburg <kernel@nn7.de>, Greg KH <greg@kroah.com>
cc: Joseph Fannin <jhf@columbus.rr.com>, Oliver Neukum <oliver@neukum.name>,
       Sergey Vlasov <vsu@altlinux.ru>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] usbhid quirks for macbook(pro) updated to 2.6.20-rc6
In-Reply-To: <Pine.LNX.4.64.0701291036040.9448@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0701301625460.9448@twin.jikos.cz>
References: <1161856438.5214.2.camel@no.intranet.wo.rk>  <1162054576.3769.15.camel@localhost>
 <200610282043.59106.oliver@neukum.org>  <200610282055.29423.oliver@neukum.name>
 <1162067266.4044.2.camel@localhost>  <20061030101202.GB9265@nineveh.rivenstone.net>
  <1165598367.19187.18.camel@localhost>  <1165716489.27637.7.camel@localhost.localdomain>
  <1166171764.3507.2.camel@localhost>  <20061215175632.GC15871@kroah.com> 
 <1166870289.11501.8.camel@localhost> <1169906927.2462.30.camel@localhost>
 <Pine.LNX.4.64.0701291036040.9448@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jan 2007, Jiri Kosina wrote:

> > > > > I've noticed that this patch is not in 2.6.20-rc1. Could you 
> > > > > please comment on what is wrong with it / whether it will ever 
> > > > > have a chance to be accepted in the way it is done ?
> > > > It's in my queue right now, sorry.  I'll catch up on it in a few hours.
> > This is the updated version for 2.6.20-rc6.
> do you have this already in your tree, or should I take it over?

I have checked that it doesn't seem to be in Greg's patchset, so I merged 
it into hid tree.

Thanks,

-- 
Jiri Kosina
