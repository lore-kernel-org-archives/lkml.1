Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751771Ab0CGX6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 18:58:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750959Ab0CGX6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 18:58:39 -0500
Date: Sun, 7 Mar 2010 15:27:44 -0800
From: Greg KH <gregkh@suse.de>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: t.a.c.henriques@googlemail.com, t.a.c.henriques@gmail.com,
       adobriyan@gmail.com, tglx@linutronix.de,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Bluetooth: fix coding style issue in hci_vhci.c This
	patch affects hci_vhci.c it fixes some warnings detected by the
	checkpath.pl tool Signed-off-by: Tiago Henriques
	<t.a.c.henriques@gmail.com>
Message-ID: <20100307232744.GA8039@suse.de>
References: <1267934631-3531-1-git-send-email-t.a.c.henriques@gmail.com> <20100307155658.GB1805@suse.de> <1267996092.3712.9.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267996092.3712.9.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 07, 2010 at 01:08:12PM -0800, Marcel Holtmann wrote:
> Hi Tiago,
> 
> > Your Subject line is a bit messed up :)
> > 
> > You need to put extra lines in your git commit so that git-send-email
> > doesn't barf on it.
> > 
> > On Sun, Mar 07, 2010 at 04:03:51AM +0000, t.a.c.henriques@googlemail.com wrote:
> > > From: root <root@balganUbuntuVM.(none)>
> > 
> > And this is incorrect.
> 
> and this goes only to linux-bluetooth@vger.kernel.org. I really have no
> idea why anybody else is on CC here. It is pure Bluetooth cleanup patch.

scripts/get_maintainer.pl lists all of these, that is why.

thanks,

greg k-h

