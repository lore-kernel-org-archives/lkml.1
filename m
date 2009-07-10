Return-Path: <linux-kernel-owner+w=401wt.eu-S1756939AbZGJVJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939AbZGJVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 17:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbZGJVJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 17:09:20 -0400
Received: from sirius.lasnet.de ([78.47.116.19]:32807 "EHLO sirius.lasnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbZGJVJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 17:09:20 -0400
Date: Fri, 10 Jul 2009 23:10:12 +0200
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: Joe Perches <joe@perches.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20090710211012.GB8273@dodger.lab.datenfreihafen.org>
References: <1247256960.11673.63.camel@Joe-Laptop.home>
 <20090710202121.GA8273@dodger.lab.datenfreihafen.org>
 <1247257612.11673.70.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247257612.11673.70.camel@Joe-Laptop.home>
X-Mailer: Mutt http://www.mutt.org/
X-KeyID: 0xDDF51665
X-Website: http://www.datenfreihafen.org/
User-Agent: Mutt/1.5.20 (2009-06-14)
Subject: Re: [PATCH] MAINTAINERS: INPUT: Add Dmitry's name to his email
 address
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On Fri, 2009-07-10 at 13:26, Joe Perches wrote:
> On Fri, 2009-07-10 at 22:21 +0200, Stefan Schmidt wrote:
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index e4a4de9..18fc1fa 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -2978,6 +2978,7 @@ F:	include/linux/inotify.h
> > >  INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
> > >  P:	Dmitry Torokhov
> > >  M:	dmitry.torokhov@gmail.com
> > > +P:	Dmitry Torokhov
> > >  M:	dtor@mail.ru
> > >  L:	linux-input@vger.kernel.org
> > >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
> > 
> > Hmm, do I miss something or is this the same line as two lines above?
> 
> You're right, it's the same name, new email address.
> It's just standardizing, a name for an email address.
> 
> Scripts that parse MAINTAINERS have difficulty
> figuring out names for addresses when the style
> isn't consistent.
> 
> At some point, it'd be nicer for people that
> manually cut and paste entries in MAINTAINERS
> to have the lines appear like:
> 
> M:	Dmitry Torokhov <dtor@mail.ru>

My bad. I did not spot the second email address. Makes more sense now. Thanks.

regards
Stefan Schmidt
