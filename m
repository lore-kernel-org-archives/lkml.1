Return-Path: <linux-kernel-owner+w=401wt.eu-S1753536AbXFOBot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbXFOBot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755555AbXFOBoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:44:34 -0400
Received: from keil-draco.com ([216.193.185.50]:50302 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754547AbXFOBod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:44:33 -0400
From: Daniel Hazelton <dhazelton@enter.net>
To: David Woodhouse <dwmw2@infradead.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Thu, 14 Jun 2007 21:44:15 -0400
User-Agent: KMail/1.9.6
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alexandre Oliva <aoliva@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu
References: <466A3EC6.6030706@netone.net.tr> <200706132129.52736.dhazelton@enter.net> <1181859896.5211.38.camel@shinybook.infradead.org>
In-Reply-To: <1181859896.5211.38.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706142144.15695.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 June 2007 18:24:55 David Woodhouse wrote:
> On Wed, 2007-06-13 at 21:29 -0400, Daniel Hazelton wrote:
> > Agreed. However, AFAICT, TiVO meets the provisions of the GPLv2 - they
> > make the source of the GPL'd part of their system available. (And I'm not
> > going to get into arguments over whether kernel modules are "derivative
> > works" or not, since those invariably end up with "They aren't, even
> > though we think they should be")
>
> Who cares about whether the module is a derivative work? That's only
> relevant when you distribute the module as a separate work. When you
> ship a combined work including both the kernel and the module in
> question, it's a _whole_ lot easier to interpret the GPL.

Agreed. I said I wasn't going to argue about it because there *ARE* 
distinctions that the law makes and the GPL ignores. You can't have it both 
ways. If the module is distributed *with* the kernel *SOURCE* then it doesn't 
matter if it's a derivative work or not, because it becomes covered by the 
kernels license. If it's distributed with the kernel *binaries* then it is 
covered by its own license. In that case the only reason you'd have a right 
to the source is if the module is considered a "derivative work".

DRH

-- 
Dialup is like pissing through a pipette. Slow and excruciatingly painful.
