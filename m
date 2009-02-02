Return-Path: <linux-kernel-owner+w=401wt.eu-S1759151AbZBBXof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151AbZBBXof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 18:44:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755233AbZBBXoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 18:44:15 -0500
Received: from kroah.org ([198.145.64.141]:46127 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754499AbZBBXoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 18:44:14 -0500
Date: Mon, 2 Feb 2009 15:02:23 -0800
From: Greg KH <greg@kroah.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: [stable] Linux 2.6.28.1
Message-ID: <20090202230223.GC32075@kroah.com>
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

This should all be resolved now with 2.6.28.3, if not, please let us
know.

thanks,

greg k-h
