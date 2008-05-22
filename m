Return-Path: <linux-kernel-owner+w=401wt.eu-S1755771AbYEVRMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbYEVRMZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 13:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbYEVRMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 13:12:17 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:47360 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589AbYEVRMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 13:12:16 -0400
Date: Thu, 22 May 2008 20:09:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Bosko Radivojevic <bosko.radivojevic@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Number of bugs - statistics
Message-ID: <20080522170956.GC2727@cs181133002.pp.htv.fi>
References: <d6c8ef150805220528w6c4911bfq2be92eaa487a0f3@mail.gmail.com> <20080522144114.GC27301@cs181133002.pp.htv.fi> <20080522075135.4933161c@infradead.org> <20080522155425.GA2727@cs181133002.pp.htv.fi> <48359DE1.8050600@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <48359DE1.8050600@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 06:22:57PM +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
> > On Thu, May 22, 2008 at 07:51:35AM -0700, Arjan van de Ven wrote:
> >> Maybe some other data:
> >> * The incoming rate of ACPI bugs has been pretty much flat the last 3
> >> years, while the number of Linux (and ACPI) users has grown
> >> significantly. The number of unfixed bugs has more than halved, from
> >> over 200 to well below 100.
> >> * The SCSI maintainer also reports that he sees flat to declining bug
> >> rates; again with the increase in Linux user base that is a good sign
> > 
> > Andrew sees and handles the majority of incoming bug reports.
> > Ask him whether he agress with this.
> > 
> > And ALSA alone has 2000 open bug reports, which makes the open ACPI or 
> > SCSI bug numbers relatively irrelevant in any "number of bugs" 
> > statistics.
> 
> Central facilities like ACPI and SCSI having relatively few [and
> according to Arjan a decreasing number of] reported unfixed bugs is...
> irrelevant?

Yes, _in any "number of bugs" statistics_ that is irrelevant.

You seem to confuse "number of bugs" with "stability".
As Arjan often emphasizes this is wrong.

We do not even have good data for "number of bug reports".
And getting data for "stability" would be a quite hard task.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

