Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbXFOUnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbXFOUnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 16:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbXFOUnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 16:43:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56134 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753354AbXFOUnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 16:43:09 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Poole <mdpoole@troilus.org>, Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david\@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706142246.57583.dhazelton@enter.net>
	<878xal2a0q.fsf@graviton.dyn.troilus.org>
	<200706150127.18069.dhazelton@enter.net>
	<87sl8tzaj1.fsf@graviton.dyn.troilus.org>
	<20070615124039.GB21120@elte.hu>
	<87fy4tz8dc.fsf@graviton.dyn.troilus.org>
	<20070615143003.GA8775@elte.hu>
	<87zm31xo3q.fsf@graviton.dyn.troilus.org>
	<20070615154200.GA17172@elte.hu>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Fri, 15 Jun 2007 17:42:35 -0300
In-Reply-To: <20070615154200.GA17172@elte.hu> (Ingo Molnar's message of "Fri\, 15 Jun 2007 17\:42\:00 +0200")
Message-ID: <orps3xx83o.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 15, 2007, Ingo Molnar <mingo@elte.hu> wrote:

> it is a false statement on your part that the executable "does not 
> function properly" if it lacks that part. Try it: take out the harddisk 
> from the Tivo (it's a bog standard IDE harddisk), put into a nice Linux 
> PC, mount it, modify a bit in the kernel image header and it will likely 
> still boot just fine on that PC.

Ok, try this: take the disk out, remove/replace/modify the signature,
put the disk back in, and tell me what it is that fail to run.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
