Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbXFOBwj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbXFOBwj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:52:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXFOBwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:52:32 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41791 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751662AbXFOBwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:52:32 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Hazelton <dhazelton@enter.net>, Chris Friesen <cfriesen@nortel.com>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr> <46718044.1040108@nortel.com>
	<orodjicpt0.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706141848.55378.dhazelton@enter.net>
	<or8xam87h1.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706141616530.14121@woody.linux-foundation.org>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 22:51:39 -0300
In-Reply-To: <alpine.LFD.0.98.0706141616530.14121@woody.linux-foundation.org> (Linus Torvalds's message of "Thu\, 14 Jun 2007 16\:31\:18 -0700 \(PDT\)")
Message-ID: <orir9q6l3o.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Linus Torvalds <torvalds@linux-foundation.org> wrote:

> It's an addiction. I'm not proud.

I guess this makes it two of us :-(

> They were basically forced to add lockdown by the content vendors.

They can do that.  They will still be able to do that with v3.

All they have to do is to throw away the keys that enable themselves
to modify the code further.

> For example, I'd rather have some GPLv2'd DVD player software that does 
> *not* come with a de-css key

libdvdread and libdvdcss are separate packages.

> So the GPLv3 actually _hinders_ people who might otherwise help the 
> community from helping, by making the license so strict that those people 
> (who are nice people, but have their options limited by stupid laws and 
> regulations) cannot use the GPLv3.

Just like v2 hinders their many customers.

Are you so sure v2 is better in this regard?

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
