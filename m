Return-Path: <linux-kernel-owner+w=401wt.eu-S1758456AbXFQIId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758456AbXFQIId (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 04:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbXFQIIU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 04:08:20 -0400
Received: from paragon.brong.net ([66.232.154.163]:43059 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754368AbXFQIIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 04:08:19 -0400
Date: Sun, 17 Jun 2007 18:08:14 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Daniel Hazelton <dhazelton@enter.net>, Bron Gondwana <brong@fastmail.fm>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070617080814.GB5440@brong.net>
References: <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <200706162310.24726.dhazelton@enter.net> <orejkbkyai.fsf@oliva.athome.lsd.ic.unicamp.br> <200706170023.03209.dhazelton@enter.net> <ory7ijjg2k.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ory7ijjg2k.fsf@oliva.athome.lsd.ic.unicamp.br>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 02:38:43AM -0300, Alexandre Oliva wrote:
> On Jun 17, 2007, Daniel Hazelton <dhazelton@enter.net> wrote:
> 
> > Ah, but giving the user half the key doesn't mean they still don't have access 
> > to the entire key. QED: Giving people half the key won't cut it under the 
> > GPLv3 (dd4)
> 
> I meant really giving, rather than giving a copy, or giving the
> original and keeping a copy.
> 
> You could make it require a pair of signatures, one from the vendor,
> that the vendor keeps, one from the user, that the vendor never sees,
> too.  Like some bank PINs, it gets generated, used to generate some
> hash (the signature for the initial installation), printed in an
> envelope for you and stored in the package along with the machine.  Or
> something like that.

Wow, and I thought losing a microsoft "certificate of authenticity" and
associated key was a pain.  Ouch.  Talk about your paper "dongle".
