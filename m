Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbXIIUXa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbXIIUXa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2007 16:23:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758837AbXIIUXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Sep 2007 16:23:22 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33276 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758709AbXIIUXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2007 16:23:21 -0400
Date: Sun, 9 Sep 2007 22:24:42 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Greg KH <greg@kroah.com>
Cc: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       len.brown@intel.com, linux-ide@vger.kernel.org, dz@debian.org,
       minyard@acm.org, j.w.r.degoede@hhs.nl, lm-sensors@lm-sensors.org,
       rlove@rlove.org, bzolnier@gmail.com, dmitry.torokhov@gmail.com,
       mzxreary@0pointer.de, stelian@popies.net, ibm-acpi@hmh.eng.br,
       ambx1@neo.rr.com, gimli@dark-green.com
Subject: Re: [PATCH] drivers/firmware: const-ify DMI API and internals
Message-ID: <20070909202442.GA21086@uranus.ravnborg.org>
References: <20070901142719.GA31990@havoc.gtf.org> <20070901153644.GA530@kroah.com> <46D98CD0.9040206@garzik.org> <20070909175142.GB32447@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070909175142.GB32447@kroah.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > I was just going to push it myself, but have no strong feelings on the 
> > matter.
> 
> Ok, you can push it, that's fine with me.  Feel free to add my:
> 	Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> if you want.
That should be "Acked-by:" since the patch does not pass via you but you
acknowledge it is OK by your Ack.

	Sam
