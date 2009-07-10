Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbZGJU1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbZGJU1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 16:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZGJU1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 16:27:07 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3210 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbZGJU1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 16:27:07 -0400
Subject: Re: [PATCH] MAINTAINERS: INPUT: Add Dmitry's name to his email
 address
From: Joe Perches <joe@perches.com>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Dmitry Torokhov <dtor@mail.ru>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090710202121.GA8273@dodger.lab.datenfreihafen.org>
References: <1247256960.11673.63.camel@Joe-Laptop.home>
	 <20090710202121.GA8273@dodger.lab.datenfreihafen.org>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 13:26:52 -0700
Message-Id: <1247257612.11673.70.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 22:21 +0200, Stefan Schmidt wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index e4a4de9..18fc1fa 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -2978,6 +2978,7 @@ F:	include/linux/inotify.h
> >  INPUT (KEYBOARD, MOUSE, JOYSTICK, TOUCHSCREEN) DRIVERS
> >  P:	Dmitry Torokhov
> >  M:	dmitry.torokhov@gmail.com
> > +P:	Dmitry Torokhov
> >  M:	dtor@mail.ru
> >  L:	linux-input@vger.kernel.org
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git
> 
> Hmm, do I miss something or is this the same line as two lines above?

You're right, it's the same name, new email address.
It's just standardizing, a name for an email address.

Scripts that parse MAINTAINERS have difficulty
figuring out names for addresses when the style
isn't consistent.

At some point, it'd be nicer for people that
manually cut and paste entries in MAINTAINERS
to have the lines appear like:

M:	Dmitry Torokhov <dtor@mail.ru>

There is a script to do this conversion.
http://lkml.org/lkml/2009/6/1/275

cheers, Joe

