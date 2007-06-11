Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbXFKKXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbXFKKXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 06:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbXFKKXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 06:23:48 -0400
Received: from paragon.brong.net ([66.232.154.163]:39168 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756983AbXFKKXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 06:23:47 -0400
Date: Mon, 11 Jun 2007 20:23:41 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tarkan Erimer <tarkan@netone.net.tr>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070611102340.GB26904@brong.net>
References: <466BB9B0.5030908@netone.net.tr> <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <466BCBBC.90305@netone.net.tr> <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm> <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com> <466C0901.4000405@netone.net.tr> <alpine.LFD.0.98.0706101025330.20321@woody.linux-foundation.org> <alpine.LFD.0.98.0706101029300.20321@woody.linux-foundation.org> <466D0A12.5030607@netone.net.tr> <20070611090348.GA18894@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070611090348.GA18894@elte.hu>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2007 at 11:03:48AM +0200, Ingo Molnar wrote:
> 
> * Tarkan Erimer <tarkan@netone.net.tr> wrote:
> 
> > > (*) And I've been pushing for that since before they even released 
> > > it - I walked out on Bill Joy at a private event where they 
> > > discussed their horrible previous Java license.
> > 
> > Thanks for making things more clear :-) Some really strong indications 
> > that Sun is very willing to,at least, "Dual-License" the OpenSolaris 
> > with GPLv3. I think; in a very short time; we will see when the GPLv3 
> > finalized and released.
> 
> that would certainly be a good and productive move from them. Note the 
> issue that others have pointed out to you: OpenSolaris is probably more 
> interested in picking up code from Linux than the other way around! :-) 
> You mentioned "dtrace" and "ZFS". Firstly, Linux already has a "dtrace" 
> equivalent. Secondly, ZFS might be interesting in theory
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Having just got my first Sun box (one of those 48 disk Thumper machines)
I can say it's very interesting in practice too.  The admin tools for
zfs are a dream to use (unlike just about everything else on Solaris
which is a bugwards compatible nightmare to use) and the attitude of
checksumming everything on to disk and checking that those checksums
match on the way back out presses my "do your own safety checking and
don't trust the hardware" buttons very much the right way - especially
with that much hardware in there.

I would love to see Sun GPL3 OpenSolaris, not so much for the code
itself (maybe not portable into Linux) but for the clarity it would
give to the patent position.  The patent peace would be portable back
to GPL2.

Bron.
