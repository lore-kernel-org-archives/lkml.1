Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbXEVWVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbXEVWVA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:21:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762829AbXEVWUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:20:22 -0400
Received: from canuck.infradead.org ([209.217.80.40]:49006 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759500AbXEVWUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:20:19 -0400
Date: Tue, 22 May 2007 15:19:57 -0700
From: Greg KH <greg@kroah.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Jeff Garzik <jeff@garzik.org>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [stable] Wanted: Allow adding new device IDs during the
	-stable cycle
Message-ID: <20070522221957.GD2302@kroah.com>
References: <46533314.10206@redhat.com> <20070522184733.GA9357@kroah.com> <46533EA8.7020602@garzik.org> <20070522193538.GA885@kroah.com> <20070522220044.GB3429@sequoia.sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070522220044.GB3429@sequoia.sous-sol.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2007 at 03:00:44PM -0700, Chris Wright wrote:
> * Greg KH (greg@kroah.com) wrote:
> > On Tue, May 22, 2007 at 03:04:08PM -0400, Jeff Garzik wrote:
> > >  Really, it is just silly to think that one-line PCI IDs patches will cause 
> > >  any harm at all, and it should be self-evident that there is clear potential 
> > >  to HELP Linux users.  That's why we're all here, right?
> > 
> > So, if there is an overwhelming majority of people that strongly feel
> > that this is a good thing, fine, we can try it out.
> 
> Yes, if it will serve -stable users better, we can give it a trial run
> to see how it goes.

Ok, let's try it.  Send on the "only add a new device id" patches and
let's see how it works out.

But we still do reserve the right to stop doing this, if it turns out
that it causes more problems.  Rembember, -stable should not be adding
new features, and I _really_ want to keep it that way, as it's the only
way that Chris and I can stay relativly sane...

thanks,

greg k-h
