Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYCKNFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYCKNFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 09:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753718AbYCKNF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 09:05:26 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:53014 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817AbYCKNF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 09:05:26 -0400
Date: Tue, 11 Mar 2008 15:04:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Meyer <thomas@m3y3r.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
Message-ID: <20080311130449.GA21157@cs181133002.pp.htv.fi>
References: <200803110014.52985.rjw@sisk.pl> <47D67992.8010308@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47D67992.8010308@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2008 at 01:22:42PM +0100, Stefan Richter wrote:
> Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10080
> > Subject		: 2.6.25-rc2: ohci1394 problem
> > Submitter	: Thomas Meyer <thomas@m3y3r.de>
> > Date		: 2008-02-20 08:47
> > References	: http://lkml.org/lkml/2008/2/20/58
> > Handled-By	: Stefan Richter <stefanr@s5r6.in-berlin.de>
> 
> Thomas wrote on 2008-02-25:
> ''So i did a "make clean" and a "make" (not a make
> -j3 as i use to do) and recompiled 2.6.25-rc3 and now it works again.
> Case closed under strange error.''
>...

Although I don't think this would cause the error, it would be nice if 
Thomas could verify that the -j3 did not cause the problem.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

