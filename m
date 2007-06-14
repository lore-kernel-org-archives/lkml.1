Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbXFNUX0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbXFNUX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 16:23:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbXFNUXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 16:23:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbXFNUXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 16:23:17 -0400
To: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
	<f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
	<20070610160531.GA12179@kroah.com>
	<f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
	<20070612184110.GB7980@kroah.com>
	<orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
	<or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070613211432.GH10008@csclub.uwaterloo.ca>
	<orodjjlbu1.fsf@oliva.athome.lsd.ic.unicamp.br>
	<20070614175305.GI10008@csclub.uwaterloo.ca>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 16:32:08 -0300
In-Reply-To: <20070614175305.GI10008@csclub.uwaterloo.ca> (Lennart Sorensen's message of "Thu\, 14 Jun 2007 13\:53\:05 -0400")
Message-ID: <or7iq6coxz.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, lsorense@csclub.uwaterloo.ca (Lennart Sorensen) wrote:

> They let you have the code and make changes to it,

Not to the software installed in the device.

What they do is like an author A who distributes a program to user B
under a non-Free Software license, and to user C under a Free Software
license.

C passes the program on to B under the same license.  Now B has two
copies of the program.  One is free, the other is not.

Except that TiVO had no right to distribute the program under non-Free
terms in the first place, because it was not the author, and the
license it had explicitly said it couldn't impose further
restrictions.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
