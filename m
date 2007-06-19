Return-Path: <linux-kernel-owner+w=401wt.eu-S1760593AbXFSFmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760593AbXFSFmQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 01:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXFSFmC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 01:42:02 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbXFSFmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 01:42:00 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, Bernd Schmidt <bernds_cb1@t-online.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Daniel Hazelton <dhazelton@enter.net>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <alpine.LFD.0.98.0706171157400.14121@woody.linux-foundation.org>
	<or3b0qgy8r.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	<ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	<or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	<orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070619012517.GL14788@delft.aura.cs.cmu.edu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Tue, 19 Jun 2007 02:40:59 -0300
In-Reply-To: <20070619012517.GL14788@delft.aura.cs.cmu.edu> (Jan Harkes's message of "Mon\, 18 Jun 2007 21\:25\:17 -0400")
Message-ID: <orbqfc5wno.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18, 2007, Jan Harkes <jaharkes@cs.cmu.edu> wrote:

> Not really, Tivo could simply sell you a box without any installed
> software.

Yes.

> The actual software is mailed to you on a credit card sized
> ROM when you activate service.

If that's a separate transaction, then yes, I believe it would not be
convered under the terms of GPLv3, but IANAL.  There might be some
catch about intent, and also about contractual obligations in the
hardware sale to provide the software (coupons anyone? :-) or some
such.


But then, that you sell specialized devices with say only MIT-licensed
software shouldn't stop you from selling CD-ROMs with GPLed software,
even if those CD-ROMs could possibly run on that device.


The GPLv3 won't remove every way in which people who want/need to stop
the user from making changes to the software could accomplishing this
(ROM).  It will just make this a bit more inconvenient, such that
vendors that have the option respect users' freedoms, and those that
find it too inconvenient respect the wishes of users who don't want
their software turned non-free.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
