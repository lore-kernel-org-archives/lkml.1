Return-Path: <linux-kernel-owner+w=401wt.eu-S1755549AbZART4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549AbZART4A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 14:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZARTzu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 14:55:50 -0500
Received: from mail.suse.de ([195.135.220.2]:37242 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754060AbZARTzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 14:55:50 -0500
Date: Sun, 18 Jan 2009 11:47:03 -0800
From: Greg KH <gregkh@suse.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.28.1
Message-ID: <20090118194703.GA16077@suse.de>
References: <20090118185408.GC6478@kroah.com> <200901182016.07267.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901182016.07267.linux@rainbow-software.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2009 at 08:16:03PM +0100, Ondrej Zary wrote:
> On Sunday 18 January 2009 19:54:08 you wrote:
> > We (the -stable team) are announcing the release of the 2.6.28.1
> > kernel.
> >
> > It contains a wide range of bugfixes, and all users of the 2.6.28 kernel
> > series are strongly encouraged to upgrade.
> 
> I do not see any fix for the broken libusb: http://lkml.org/lkml/2009/1/2/47
> 
> libusb is not only broken on x86_64, but everywhere. My camera does not work 
> with gphoto2 in 2.6.28 (I'm using x86). The patch linked above fixes the 
> problem for me.

Yes, that patch is still in the queue for the next .28 release.

thanks,

greg k-h
