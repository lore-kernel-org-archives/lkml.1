Return-Path: <linux-kernel-owner+w=401wt.eu-S1758164AbXFSVVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758164AbXFSVVW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 17:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbXFSVVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 17:21:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbXFSVVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 17:21:14 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	<ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	<or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	<orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070619012517.GL14788@delft.aura.cs.cmu.edu>
	<orbqfc5wno.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070619200156.GA8812@delft.aura.cs.cmu.edu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 18:20:24 -0300
In-Reply-To: <20070619200156.GA8812@delft.aura.cs.cmu.edu> (Jan Harkes's message of "Tue\, 19 Jun 2007 16\:01\:56 -0400")
Message-ID: <orwsxzzlnr.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 19, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:

> On Tue, Jun 19, 2007 at 02:40:59AM -0300, Alexandre Oliva wrote:
>> > The actual software is mailed to you on a credit card sized
>> > ROM when you activate service.
> ...
>> The GPLv3 won't remove every way in which people who want/need to stop
>> the user from making changes to the software could accomplishing this
>> (ROM).  It will just make this a bit more inconvenient, such that
>> vendors that have the option respect users' freedoms, and those that
>> find it too inconvenient respect the wishes of users who don't want
>> their software turned non-free.

> Or are you saying that all that anti-tivoization language that adds
> complex requirements which change depending on the market some device
> happens to be sold in

You allude to the definition of User Product, not geographies, I
suppose.

> and which will most likely make GPLv3 software unusable for various
> applications ranging from medical equipment to financial transaction
> systems (and probably others)

Not unusable, except perhaps for the one example about credit card
terminals presented so far.

> is there to just make it a _bit_ more inconvenient for vendors to
> implement a tivo-like scheme?

I'm not sure they find it to be "just a bit".

Point is to keep Free Software Free freedoms, and ROM doesn't make it
non-Free, so this provision is a means to ensure the compliance with
the wishes of users who want their software to not be used in ways
that make it non-Free.

As it so happens, this also places economic pressure on vendors who
tivoize, such that they either face more costly solutions, or enable
users to tinker with the software as well.  And if neither ROM nor
permission are an option for the vendor, well, too bad, the author
gets to decide how his software is to be used, right?

> So what exactly is the point of all this then?

Keeping Free Software Free.

(and, as a consequence that many of you may welcome, keeping
open-source software open source)

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
