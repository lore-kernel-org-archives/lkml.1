Return-Path: <linux-kernel-owner+w=401wt.eu-S1759402AbXFPBDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402AbXFPBDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 21:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752790AbXFPBDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 21:03:06 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:42290
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597AbXFPBDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 21:03:05 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Fri, 15 Jun 2007 21:03:05 -0400
User-Agent: KMail/1.9.6
Cc: Michael Gerdau <mgd@technosis.de>, Daniel Hazelton <dhazelton@enter.net>,
       Alexandre Oliva <aoliva@redhat.com>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <200706150825.15491.mgd@technosis.de> <alpine.LFD.0.98.0706150913480.14121@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0706150913480.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706152103.06921.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 June 2007 13:03:53 Linus Torvalds wrote:

> 	      But does Red Hat actually give you *all* the rights they
> 	      hold on the DVD? No, they definitely do not. They hold a
> 	      compilation copyright on RHEL, and they very  much do *not*
> 	      give you the right to copy the whole distribution and sell
> 	      it as RHEL. You only get the rights to the individual
> 	      pieces, not to the whole thing!

Technically what they're holding back is _trademark_ rights, which are a 
different area of IP law and not addressed by the GPL.  (I know you know 
this, but just for the record...)

The five main areas of IP law as I understand them are copyright, patent, 
trademark, contract, and trade secret.  Each of which is a different animal 
with a different legal foundation and different enabling legislation.  The 
GPL is a copyright license with some language about patents.  It is not based 
on contract law (although that's a common misperception that Lawrence Lessig 
and Eben Moglen have spent some effort debunking), and doesn't even mention 
trademarks.

So Red Hat isn't saying "you can use some of our copyrights but not others", 
last I heard all of their copyrights are licensed GPLv2 as a matter of 
corporate policy.  What you can't use is their trademarked name or logo, 
because they are explicitly refusing to license the trademarks to third 
parties.

And under GPLv2, this is allowed.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
