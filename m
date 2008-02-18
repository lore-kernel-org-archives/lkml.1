Return-Path: <linux-kernel-owner+w=401wt.eu-S1758659AbYBREre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758659AbYBREre (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 23:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756291AbYBREr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 23:47:27 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54302 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYBREr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 23:47:26 -0500
Date: Sun, 17 Feb 2008 20:52:09 -0800
From: Greg KH <greg@kroah.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: Plans for mISDN? Was: [PATCH 00/14] [ISDN] ...
Message-ID: <20080218045209.GA15141@kroah.com>
References: <098123kjff90231nv098233rnvd908u234@garzik.org> <20080217195235.GN14588@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080217195235.GN14588@uranus.ravnborg.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 17, 2008 at 08:52:35PM +0100, Sam Ravnborg wrote:
> Hi Karsten et al.
> 
> Seeing the work Jeff puts into ISDN I was wondering what are the
> state of mISDN. Will we soon see mISDN hit the tree or has
> development stalled?
> 
> I was wondering if Jeff should go for the much simpler patch:

If Jeff does that, I still can't drop those PCI functions from the PCI
core, which I desperatly want to do as they do not play nice with modern
systems (meaning hotplug...).

So either way, I think his patches should go in.

thanks,

greg k-h
