Return-Path: <linux-kernel-owner+w=401wt.eu-S1763031AbXGWGoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763031AbXGWGoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXGWGoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:44:25 -0400
Received: from fnoeppeil48.netpark.at ([217.175.205.176]:3969 "EHLO
	roarinelk.homelinux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbXGWGoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:44:24 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jul 2007 02:44:24 EDT
Date: Mon, 23 Jul 2007 08:37:41 +0200
From: Manuel Lauss <mano@roarinelk.homelinux.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andreas Messer <andreas.messer@stud-mail.uni-wuerzburg.de>,
       linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [BUG] firewire: mass-storage i/o-problems
Message-ID: <20070723063741.GA32240@roarinelk.homelinux.net>
References: <200707222332.12270.andreas.messer@stud-mail.uni-wuerzburg.de> <46A3E973.6090701@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A3E973.6090701@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jul 23, 2007 at 01:34:11AM +0200, Stefan Richter wrote:

<massive bugreport snipped>

> > Software:
> > Kernel Vanilla 2.6.22, gcc 4.1.2. 
> > 
> > On another PC same problem, but replugging one or two times get the thing 
> > working. 
> 
> Which controller does this other PC have?

I too experience these bugs with the new fw stack; this time with a TI
OHCI-1394a combo chip in 2 different laptops and a Via 1394 pci addon card.
The target is a an external hd enclosure with an Oxford Semi chip.

Thanks,
	Manuel Lauss
