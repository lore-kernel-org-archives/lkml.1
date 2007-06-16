Return-Path: <linux-kernel-owner+w=401wt.eu-S1759554AbXFPCQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554AbXFPCQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 22:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758147AbXFPCQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 22:16:36 -0400
Received: from paragon.brong.net ([66.232.154.163]:35824 "EHLO
	paragon.brong.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758180AbXFPCQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 22:16:35 -0400
Date: Sat, 16 Jun 2007 12:16:30 +1000
From: Bron Gondwana <brong@fastmail.fm>
To: Alexandre Oliva <aoliva@redhat.com>
Cc: Bron Gondwana <brong@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Daniel Hazelton <dhazelton@enter.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070616021630.GA30660@brong.net>
References: <20070614112329.3645c397@the-village.bc.nu> <20070614103846.GA7902@elte.hu> <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614195517.GA4933@elte.hu> <orzm329s9k.fsf@oliva.athome.lsd.ic.unicamp.br> <20070614235004.GA14952@elte.hu> <20070615041149.GA6741@brong.net> <orzm313hge.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615072322.GA7594@brong.net> <orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <orabv110k5.fsf@oliva.athome.lsd.ic.unicamp.br>
Organization: brong.net
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2007 at 04:26:34PM -0300, Alexandre Oliva wrote:
> On Jun 15, 2007, Bron Gondwana <brong@fastmail.fm> wrote:
> 
> > What happens if you're debugging something you think is a bug in the
> > Linux kernel and then you run bang into some interactions that make you
> > think the bug might be in the BIOS instead.
> 
> > have denied your freedom to modify and debug the system they sold you
> 
> If the bug is in the non-GPLed BIOS, not in the GPLed code, too bad.
> One more reason to dislike non-Free Software.

If the bug is in the non-GPLed binary module, not in the GPLed code, too
bad.  One more reason to dislike non-Free Software.

It's the same argument from the other direction.  The BIOS is linked
(inside the machine, sure) to the kernel for all intents and purposes
through a defined interface.  This doesn't affect the BIOS developers
who ship me a machine on to which I then install Linux, but it _does_
affect a hardware vendor who ships me a system with Linux pre-installed,
because it could easily be argued that they linked the BIOS with the
Linux kernel and hence produced a combined work (remember, they reserve
the right to modify the BIOS, but don't give that that right to me) and
the BIOS should now come under the GPL.

Talk about your chilling effects.  It's a strong reason for vendors not
to ship GPL3 or GPL2[your interpretation] code pre-installed while the
legal boundaries of work combination are in any way grey.

Regards,

Bron.
