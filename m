Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbYFJM6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbYFJM6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 08:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYFJM6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 08:58:17 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:39077 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYFJM6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 08:58:16 -0400
Date: Tue, 10 Jun 2008 15:57:18 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, len.brown@intel.com
Cc: Ben Dooks <ben@fluff.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
Subject: ACPI pull for 2.6.26?
Message-ID: <20080610125718.GA16149@cs181133002.pp.htv.fi>
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org> <20080605144318.GA5839@fluff.org.uk> <alpine.LFD.1.10.0806061134380.3473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0806061134380.3473@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2008 at 11:35:25AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 5 Jun 2008, Ben Dooks wrote:
> > 
> > Is it too early to ask how long before 2.6.26 is released?
> 
> Hmm. Depends on just how the regression list ends up looking. I don't 
> think we're in bad shape, so maybe -rc7 can be the last one. 

I'm (as usual) not that optimistic, but one remark:

Several ACPI regressions have pending patches, and the last merge from 
the ACPI tree was in April.

Having a bigger ACPI merge after what might be the last -rc doesn't 
sound good.

Len, what's the status regarding an ACPI pull for 2.6.26?

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

