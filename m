Return-Path: <linux-kernel-owner+w=401wt.eu-S1756210AbYDFVoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210AbYDFVoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 17:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753537AbYDFVoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 17:44:09 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:37074 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbYDFVoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 17:44:08 -0400
Date: Mon, 7 Apr 2008 00:43:33 +0300
From: Adrian Bunk <bunk@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Toralf Feorster <toralf.foerster@gmx.de>
Subject: Re: TUNER_TDA8290=y, VIDEO_DEV=n build error
Message-ID: <20080406214333.GH30987@cs181133002.pp.htv.fi>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.iUB.YHW9HB@albercik> <20080404084754.GA10993@cs181133002.pp.htv.fi> <200804041137.40582.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200804041137.40582.rjw@sisk.pl>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2008 at 11:37:40AM +0200, Rafael J. Wysocki wrote:
> On Friday, 4 of April 2008, Adrian Bunk wrote:
> > On Fri, Apr 04, 2008 at 01:20:32AM +0200, Rafael J. Wysocki wrote:
> > > The following report is on the current list of known regressions
> > > from 2.6.24.  Please verify if the issue is still present in the
> > > mainline.
> > 
> > When you asked me just 2 days ago exactly the same question in the 
> > Bugzilla entry I immediately confirmed it's still present.
> > 
> > Was anything wrong with my answer (and the subsequent discussions) that 
> > you now also ask Toralf for confirmation?
> 
> This text is automatically added to the messages sent in replies to the main
> report.
> 
> Well, it probably could be better.  I'm open for suggestions. :-)

First of all you try to get the tracking of all bugs into Bugzilla, and 
now you've sent a batch of emails where the answers will not get into 
Bugzilla automatically.

As an example, for the bug we are talking about the main value of you 
asking me in Bugzilla was not that I confirmed it's still present, the 
main value was that this caused Mauro to make a fix. What would have 
happened if Toralf had answered in an email that the bug is still 
present?

And especially for trickier stuff like suspend/resume problems it might 
also make sense to send the email to all people who might possibly be 
involved with the bug - even if this means putting all email addresses 
from 5 MAINTAINERS entries into one email. It takes a bit more time when 
writing the emails, but my experience was it's worth it.

> Thanks,
> Rafael

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

