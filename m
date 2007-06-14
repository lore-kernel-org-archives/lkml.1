Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbXFNJah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbXFNJah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 05:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751123AbXFNJa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 05:30:29 -0400
Received: from khc.piap.pl ([195.187.100.11]:58944 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbXFNJa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 05:30:29 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm>
	<200706132042.02728.dhazelton@enter.net>
	<ord4zzjm5u.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132347.42371.dhazelton@enter.net>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 14 Jun 2007 11:30:25 +0200
In-Reply-To: <200706132347.42371.dhazelton@enter.net> (Daniel Hazelton's message of "Wed, 13 Jun 2007 23:47:42 -0400")
Message-ID: <m3ejke6fym.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Hazelton <dhazelton@enter.net> writes:

> Exactly. And I don't see anything about a TiVO (or any device that, like a 
> TiVO, requires binaries that run on it to be digitally signed) that stops
> you 
> from exercising the "freedoms" guaranteed by the GPL. As I said before, what 
> it does is stop you from violating the license on the hardware.

BTW: don't they sell their hardware (as well)? I think it should be
easy to replace the ROMs (EPROMs? flash ROMs?) using some diagnostic
clip and/or JTAG. Unless the CPU itself verifies ROM signatures,
they shouldn't matter.
-- 
Krzysztof Halasa
