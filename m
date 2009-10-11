Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZJKPQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZJKPQB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 11:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbZJKPP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 11:15:59 -0400
Received: from kroah.org ([198.145.64.141]:43147 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752394AbZJKPP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 11:15:59 -0400
Date: Sun, 11 Oct 2009 07:42:17 -0700
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mike Lothian <mike@fireburn.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Matthias Hopf <mhopf@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Samsung Backlight Patch
Message-ID: <20091011144217.GA9975@kroah.com>
References: <f3f71ab90910071414n482eca2dm18108c79ee08028d@mail.gmail.com> <20091007211916.GA4217@kroah.com> <f3f71ab90910071431g524fa807ib67f5fcfef7c70d1@mail.gmail.com> <20091007225828.GA7892@kroah.com> <20091011090403.GA1414@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091011090403.GA1414@ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 11, 2009 at 11:04:03AM +0200, Pavel Machek wrote:
> On Wed 2009-10-07 15:58:28, Greg KH wrote:
> > On Wed, Oct 07, 2009 at 10:31:44PM +0100, Mike Lothian wrote:
> > > 2009/10/7 Greg KH <greg@kroah.com>:
> > > > On Wed, Oct 07, 2009 at 10:14:37PM +0100, Mike Lothian wrote:
> > > >> Hi
> > > >>
> > > >> I was hoping the following patch could be included in 2.6.32 so it
> > > >> would hopefully end up in the next round of distros
> > > >>
> > > >> It adds backlight support for some Samsung laptops
> > > >
> > > > You seem to have lost the original authorship of this patch, and not
> > > > included your signed-off-by for it.
> > > >
> > > > Which means it can't be applied :(
> ...
> > > It definitely has +MODULE_AUTHOR("Greg Kroah-Hartman
> > > <gregkh@suse.de>"); at the bottom
> > > 
> > > I certainly wasn't trying to steal credit for your work
> > 
> > I mean on the patch, when submitting it, you need a:
> > 	From: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > as the first line.
> > 
> > > Who should sign it off?
> > 
> > As I stated before, I can not sign off on this patch anymore, but I
> > would like my authorship to remain.  Someone needs to sign off on it...
> 
> That's quite crazy, no?

Yes it is.

> DCO,  a). You say you created the patch. Do you want to say you did
> not have right to submit it? Or do you want to say it is not under
> GPL?
> 
> What is going on?

I can not say, sorry.

greg k-h
