Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1754709AbYJBUEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYJBUEO (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 2 Oct 2008 16:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754285AbYJBUD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 16:03:56 -0400
Received: from kroah.org ([198.145.64.141]:60561 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754276AbYJBUDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 16:03:55 -0400
Date: Thu, 2 Oct 2008 13:00:23 -0700
From: Greg KH <greg@kroah.com>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: Dave <kilroyd@googlemail.com>, TJ <linux@tjworld.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Casual J. Programmer" <casualprogrammer@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Alexander Shirshikov <alexander.shirshikov@gmail.com>
Subject: Re: Agere Hermes source-code: copyright situation
Message-ID: <20081002200023.GC20902@kroah.com>
References: <200809290949.35749.arvidjaar@mail.ru> <20081001200039.GA29874@kroah.com> <48E400FA.2090305@gmail.com> <200810020637.27321.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810020637.27321.arvidjaar@mail.ru>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2008 at 06:37:18AM +0400, Andrey Borzenkov wrote:
> TJ you can answer me using arvidjaar (at) newmail dot ru. Hopefully
> one of them works. Re WPA2 - there is no information how to setup
> CCMP/AES (even if firmware supports it); so no WPA2.
> 
> On Thursday 02 October 2008, Dave wrote:
> > Greg KH wrote:
> > > On Wed, Oct 01, 2008 at 05:40:29PM +0100, TJ wrote:
> > >> On Wed, 2008-10-01 at 14:13 +0400, Andrey Borzenkov wrote:
> > >>>On Wednesday 01 October 2008, Greg KH wrote:
> > >>>> On Mon, Sep 29, 2008 at 09:49:34AM +0400, Andrey Borzenkov wrote:
> > >>>>> I have here driver that can be built for two different types of
> > >>>>> hardware from basically the same sources (this is port of old Agere
> > >>>>> drivers for Hermes-I/Hermes-II chipsets).
> > >>>> 
> > >>>> Cool, do you have a link to the code, I'd be glad to add it to
> > >>>> drivers/staging/ if it's not in a fully-mergable state yet to get wider
> > >>>> users for it.
> > >>>
> > >>> You can look at it here: http://arvidjaar.newmail.ru/wlags49.tar.bz
> > >>>
> > >>> I doubt that it is suitable for inclusion at current state if ever.
> > >>> This is taken directly from Agere 2.4 sources; the only parts that were
> > >>> touched are kernel glue and wireless extensions interface.
> > >>>
> > >>> And it is not GPL'ed, of course. I attach E-Mail I received a while
> > >>> back with answere from Agere legal department.
> > >>
> > >> I'm attaching the original email I sent to Agere and their response for
> > >> the record, hoping it helps clarify the legal position.
> > > 
> > > Very nice, thanks for forwarding this on.
> > > 
> > > As the license is BSD, that means we can place it in the kernel tree.
> > > Do you all mind if I add it to the drivers/staging/ directory so you can
> > > work on cleaning it up within the main kernel tree infrastructure?
> >
> 
> I do not mind but it is likely makes no sense for H-I now; and
> I do not own H-II myself so cannot work on it. If we are focusing on
> H-2/2.5, it would make more sense to make similar modifications to
> 7.22 driver set from Agere to avoid overlap with Orinoco.

Ok, let me know what you think is the best thing to do, and I'll be glad
to help you out with it.

thanks,

greg k-h
