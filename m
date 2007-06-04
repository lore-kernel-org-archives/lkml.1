Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbXFDUzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbXFDUzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 16:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbXFDUzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 16:55:47 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49007 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753599AbXFDUzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 16:55:47 -0400
Date: Mon, 4 Jun 2007 22:55:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Andi Kleen <ak@suse.de>, Jiri Kosina <jikos@jikos.cz>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: thinkpad testers wanted (was Re: 2.6.22-rc[23]: blinking capslock led, stuck keys?)
Message-ID: <20070604205535.GC2711@elf.ucw.cz>
References: <20070604112426.GA2707@elf.ucw.cz> <20070604130903.GC1971@elf.ucw.cz> <Pine.LNX.4.64.0706041511010.29896@twin.jikos.cz> <200706041543.49071.ak@suse.de> <20070604135427.GA19466@elf.ucw.cz> <d120d5000706040702q3b5251e8oc5e9f3c198f060bd@mail.gmail.com> <20070604141345.GB2059@elf.ucw.cz> <d120d5000706040818t81d29ebi703746267693d375@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d120d5000706040818t81d29ebi703746267693d375@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-06-04 11:18:48, Dmitry Torokhov wrote:
> On 6/4/07, Pavel Machek <pavel@ucw.cz> wrote:
> >
> >Hmm, this needs to be ran from console (not X). Can someone with
> >thinkpad try this?
> 
> Are you saying it works OK when run in X?

setleds does not work in X, so there's no problem there.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
