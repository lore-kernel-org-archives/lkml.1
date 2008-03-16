Return-Path: <linux-kernel-owner+w=401wt.eu-S1752396AbYCPOEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbYCPOEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 10:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbYCPOEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 10:04:35 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:39165 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbYCPOEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 10:04:35 -0400
Date: Sun, 16 Mar 2008 16:04:22 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Chr <chunkeey@web.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5-git5: Reported regressions from 2.6.24
Message-ID: <20080316140422.GE4902@cs181133002.pp.htv.fi>
References: <200803160112.50874.rjw@sisk.pl> <200803161410.46977.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200803161410.46977.chunkeey@web.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2008 at 02:10:46PM +0100, Chr wrote:
> On Sunday 16 March 2008 01:12:50 Rafael J. Wysocki wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10207
> > Subject         : INFO: task mount:11202 blocked for more than 120 seconds
> > Submitter       : Christian Kujau <lists@nerdbynature.de>
> > Date            : 2008-03-07 21:32 (9 days old)
> > References      : http://lkml.org/lkml/2008/3/7/308
> >                   http://lkml.org/lkml/2008/3/9/186
> 
> well, there's another bug-entry about the same problem there: 
> http://bugzilla.kernel.org/show_bug.cgi?id=10242
> 
> can you anyhow merge these two? (because the other one contains
> some patches (unfortunately not final) )
>...

How do you know for sure it's the same problem?

An example from doing regression tracking for an earlier kernel:
There were four similar sounding regression reports.
Three for one regression.
And the fourth turned out to be a completely different regression.

Most likely it will turn out these two reports are for the same 
regression, but until that's verified it mustn't be assumed that
they are for sure for the same regression.

> Regards,
> 	Chr.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

