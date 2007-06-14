Return-Path: <linux-kernel-owner+w=401wt.eu-S1752370AbXFNFI1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbXFNFI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 01:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750747AbXFNFIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 01:08:19 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745AbXFNFIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 01:08:18 -0400
To: Daniel Hazelton <dhazelton@enter.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706132121.04532.dhazelton@enter.net>
	<orhcpbjnqj.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706132304.21984.dhazelton@enter.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 02:07:25 -0300
In-Reply-To: <200706132304.21984.dhazelton@enter.net> (Daniel Hazelton's message of "Wed\, 13 Jun 2007 23\:04\:21 -0400")
Message-ID: <ork5u7i0oi.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:

> User B buys the router and modifies the kernel so it drives the WiFi to an 
> output power twice that which it is licensed to carry.
> FCC finds out and prosecutes User B for violating the regulations.

Ok so far.

> FCC then pulls the small companies license until they change their
> hardware so the driver can't push it to transmit at a higher power
> level and levies a fine.

I'd say this is unfair, but if it can happen, then maybe the small
company could have been more careful about the regulations.  There are
various ways to prevent these changes that don't involve imposing
restrictions of modification on any software in the device, all the
way from hardware-constrained output power to hardware-verified
authorized configuration parameters.

> Growing the base of installed GPL covered software,

When this doesn't bring freedom to people, when people can't actually
enjoy the freedoms that the software is supposed to provide, I don't
see why this would be a good thing.  What's the merit in being able to
claim "vendor X chose my Free Software and locked it down such that
users don't get the freedoms I meant for them, and I'm happy about it?"

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
