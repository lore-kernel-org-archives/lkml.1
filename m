Return-Path: <linux-kernel-owner+w=401wt.eu-S1758252AbXFOCIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758252AbXFOCIw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 22:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXFOCIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 22:08:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbXFOCIp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 22:08:45 -0400
To: Rob Landley <rob@landley.net>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>,
       "Daniel Hazelton" <dhazelton@enter.net>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "Greg KH" <greg@kroah.com>,
       "debian developer" <debiandev@gmail.com>, david@lang.hm,
       "Tarkan Erimer" <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <466A3EC6.6030706@netone.net.tr>
	<200706141014.21574.rgetz@blackfin.uclinux.org>
	<or1wgefmyn.fsf@oliva.athome.lsd.ic.unicamp.br>
	<200706141944.21280.rob@landley.net>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 14 Jun 2007 23:07:45 -0300
In-Reply-To: <200706141944.21280.rob@landley.net> (Rob Landley's message of "Thu\, 14 Jun 2007 19\:44\:19 -0400")
Message-ID: <orabv26kcu.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 14, 2007, Rob Landley <rob@landley.net> wrote:

> On Thursday 14 June 2007 13:46:40 Alexandre Oliva wrote:

>> Well, then, ok: do all that loader and hardware signature-checking
>> dancing, sign the image, store it in the machine, and throw the
>> signing key away.  This should be good for the highly-regulated areas
>> you're talking about.  And then, since you can no longer modify the
>> program, you don't have to let the user do that any more.  Problem
>> solved.

> A) Does that actually satisfy the terms of GPLv3?

I think so:

  this requirement does not apply if neither you nor any third party
  retains the ability to install modified object code on the User
  Product

> If so, can't they just wait until they get sued and destroy the keys
> then?

I don't think this woulnd't satisfy the above.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
