Return-Path: <linux-kernel-owner+w=401wt.eu-S1763302AbZCaPb3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763302AbZCaPb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 11:31:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762846AbZCaPai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 11:30:38 -0400
Received: from mx1.moondrake.net ([212.85.150.166]:39730 "EHLO
	mx1.mandriva.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763155AbZCaPag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 11:30:36 -0400
X-Greylist: delayed 1715 seconds by postgrey-1.27 at vger.kernel.org; Tue, 31 Mar 2009 11:30:35 EDT
X-Spam-Virus: No
To: Jeff Garzik <jeff@garzik.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
X-URL: <http://www.mandrivalinux.com/
References: <20090327051338.GP6239@mit.edu>
	<20090327055750.GA18065@srcf.ucam.org>
	<20090327062114.GA18290@srcf.ucam.org> <20090327112438.GQ6239@mit.edu>
	<20090327145156.GB24819@srcf.ucam.org>
	<20090327150811.09b313f5@lxorguk.ukuu.org.uk>
	<20090327152221.GA25234@srcf.ucam.org>
	<20090327161553.31436545@lxorguk.ukuu.org.uk>
	<20090327162841.GA26860@srcf.ucam.org>
	<20090327165150.7e69d9e1@lxorguk.ukuu.org.uk>
	<20090327170208.GA27646@srcf.ucam.org>
	<alpine.LFD.2.00.0903271032090.3994@localhost.localdomain>
	<49CD2C47.4040300@garzik.org>
	<alpine.LFD.2.00.0903271443440.3994@localhost.localdomain>
	<49CD4DDF.3000001@garzik.org>
	<alpine.LFD.2.00.0903271511230.3994@localhost.localdomain>
	<alpine.LFD.2.00.0903271522210.3994@localhost.localdomain>
	<49CD7B10.7010601@garzik.org>
From: Thierry Vignaud <tvignaud@mandriva.com>
Organization: Mandriva
Date: Tue, 31 Mar 2009 17:01:59 +0200
In-Reply-To: <49CD7B10.7010601@garzik.org> (Jeff Garzik's message of "Fri\, 27 Mar 2009 21\:19\:12 -0400")
Message-ID: <m2k565splk.fsf@vador.mandriva.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> > Of course, your browsing history database is an excellent example of
> > something you should _not_ care about that much, and where
> > performance is a lot more important than "ooh, if the machine goes
> > down suddenly, I need to be 100% up-to-date". Using fsync on that
> > thing was just stupid, even 
> 
> If you are doing a ton of web-based work with a bunch of tabs or
> windows open, you really like the post-crash restoration methods that
> Firefox now employs.  Some users actually do want to
> checkpoint/restore their web work, regardless of whether it was the
> browser, the window system or the OS that crashed.

This is all about tradeoff.
I guess everybody can afford loosing the last 30 seconds of history (or
5mn ...).
That's not that much of lost work...
