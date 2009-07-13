Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbZGMDps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbZGMDps (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 23:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZGMDpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 23:45:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:59925 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227AbZGMDpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 23:45:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Hngn/3rBM0AX0VQAJqXmQITUU/omGbiZuJNV8NVqRHCLVF7ucPuUYMOBn1Tp9LshpR
         soEIe6Bw0lPjIa9QbDD6OA+E5aCStPRsQrHxxLz8197S4TOhtXzYJQJkD5ItcqzwTWw/
         F1ElSC+BgLfOQo4RSC6oygvnlD/Y+9BWHhZ3k=
Date: Sun, 12 Jul 2009 20:45:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] MAINTAINERS: INPUT: Add Dmitry's name to his email
	address
Message-ID: <20090713034538.GD10819@dtor-d630.eng.vmware.com>
References: <1247256960.11673.63.camel@Joe-Laptop.home> <20090710202121.GA8273@dodger.lab.datenfreihafen.org> <1247257612.11673.70.camel@Joe-Laptop.home> <20090710211012.GB8273@dodger.lab.datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710211012.GB8273@dodger.lab.datenfreihafen.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 10, 2009 at 11:10:12PM +0200, Stefan Schmidt wrote:
> Hello.
> 
> On Fri, 2009-07-10 at 13:26, Joe Perches wrote:
> > On Fri, 2009-07-10 at 22:21 +0200, Stefan Schmidt wrote:
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index e4a4de9..18fc1fa 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -2978,6 +2978,7 @@ F:	include/linux/inotify.h
> > > >  INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
> > > >  P:	Dmitry Torokhov
> > > >  M:	dmitry.torokhov@gmail.com
> > > > +P:	Dmitry Torokhov
> > > >  M:	dtor@mail.ru
> > > >  L:	linux-input@vger.kernel.org
> > > >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
> > > 
> > > Hmm, do I miss something or is this the same line as two lines above?
> > 
> > You're right, it's the same name, new email address.
> > It's just standardizing, a name for an email address.
> > 
> > Scripts that parse MAINTAINERS have difficulty
> > figuring out names for addresses when the style
> > isn't consistent.
> > 
> > At some point, it'd be nicer for people that
> > manually cut and paste entries in MAINTAINERS
> > to have the lines appear like:
> > 
> > M:	Dmitry Torokhov <dtor@mail.ru>
> 
> My bad. I did not spot the second email address. Makes more sense now. Thanks.
> 

Yeah, I am very important and thus have 2 e-mail addresses ;)

-- 
Dmitry
