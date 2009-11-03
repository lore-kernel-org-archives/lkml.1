Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZKCTEl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZKCTEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:04:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbZKCTEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:04:41 -0500
Received: from sasquatch.hezmatt.org ([70.85.129.92]:33532 "EHLO
	sasquatch.hezmatt.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbZKCTEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:04:40 -0500
X-Greylist: delayed 485 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 14:04:40 EST
Date: Wed, 4 Nov 2009 05:56:35 +1100
From: Matthew Palmer <mpalmer@hezmatt.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, kernel <kernel@avr32linux.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] AT91/AVR32 some common macros
Message-ID: <20091103185635.GE8322@hezmatt.org>
References: <4AF07242.3070803@atmel.com> <alpine.LFD.2.01.0911031014340.31845@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0911031014340.31845@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 10:15:38AM -0800, Linus Torvalds wrote:
> On Tue, 3 Nov 2009, Nicolas Ferre wrote:
> > 
> > If it not bother you too much to pull such a tiny and 
> > trivial piece of code, can you please pull:
> > 
> >   git://github.com/at91linux/linux-2.6-at91.git for-linus
> 
> 	"fatal: The remote end hung up unexpectedly"

Something was hinky with the repository; I don't know why, but it was
missind the git-daemon-export-ok flag file.  It's working now.

- Matt
