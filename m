Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZJKJEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZJKJEu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 05:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754125AbZJKJEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 05:04:49 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56542 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbZJKJEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 05:04:48 -0400
Date: Sun, 11 Oct 2009 11:04:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Greg KH <greg@kroah.com>
Cc: Mike Lothian <mike@fireburn.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Matthias Hopf <mhopf@suse.de>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: Samsung Backlight Patch
Message-ID: <20091011090403.GA1414@ucw.cz>
References: <f3f71ab90910071414n482eca2dm18108c79ee08028d@mail.gmail.com> <20091007211916.GA4217@kroah.com> <f3f71ab90910071431g524fa807ib67f5fcfef7c70d1@mail.gmail.com> <20091007225828.GA7892@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091007225828.GA7892@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-10-07 15:58:28, Greg KH wrote:
> On Wed, Oct 07, 2009 at 10:31:44PM +0100, Mike Lothian wrote:
> > 2009/10/7 Greg KH <greg@kroah.com>:
> > > On Wed, Oct 07, 2009 at 10:14:37PM +0100, Mike Lothian wrote:
> > >> Hi
> > >>
> > >> I was hoping the following patch could be included in 2.6.32 so it
> > >> would hopefully end up in the next round of distros
> > >>
> > >> It adds backlight support for some Samsung laptops
> > >
> > > You seem to have lost the original authorship of this patch, and not
> > > included your signed-off-by for it.
> > >
> > > Which means it can't be applied :(
...
> > It definitely has +MODULE_AUTHOR("Greg Kroah-Hartman
> > <gregkh@suse.de>"); at the bottom
> > 
> > I certainly wasn't trying to steal credit for your work
> 
> I mean on the patch, when submitting it, you need a:
> 	From: Greg Kroah-Hartman <gregkh@suse.de>
> 
> as the first line.
> 
> > Who should sign it off?
> 
> As I stated before, I can not sign off on this patch anymore, but I
> would like my authorship to remain.  Someone needs to sign off on it...

That's quite crazy, no?

DCO,  a). You say you created the patch. Do you want to say you did
not have right to submit it? Or do you want to say it is not under
GPL?

What is going on?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
