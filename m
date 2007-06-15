Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbXFOBUo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbXFOBUo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:20:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbXFOBUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:20:36 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:36048
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016AbXFOBUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:20:35 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Alexandre Oliva <aoliva@redhat.com>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 21:20:35 -0400
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <alpine.LFD.0.98.0706141545470.14121@woody.linux-foundation.org> <orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br>
In-Reply-To: <orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706142120.36902.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 19:20:19 Alexandre Oliva wrote:
> > But not within the confines of the Linux kernel. Within the Linux kernel,
> > the GPLv2 rules - and "GPLv2+" becomes just "GPLv2", since the GPLv3 is
> > not compatible with v2.
>
> I understand this very well.  You'd have to get the kernel upgraded to
> GPLv3 in order to accept the contribution.

Why do you keep saying "upgraded" to GPLv3?  How is it an improvement to move 
from a small, simple, elegant, and tested implementation to something that's 
more complicated, less elegant, less coherent, totally untested, and full of 
numerous special cases?

Bumping a version number is not in indicator of quality, and spending over 
twice as much text to express the same legal principles is not an 
improvement.  So far, you haven't brought up a single reason to use v3 except 
for a higher version number.  (Not that I'm asking you to.)  You've just 
tried to argue that it isn't WORSE than the existing license.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
