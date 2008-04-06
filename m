Return-Path: <linux-kernel-owner+w=401wt.eu-S1756449AbYDFV7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756449AbYDFV7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 17:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755139AbYDFV7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 17:59:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50730 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754007AbYDFV7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 17:59:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: TUNER_TDA8290=y, VIDEO_DEV=n build error
Date: Sun, 6 Apr 2008 23:59:17 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Toralf Feorster <toralf.foerster@gmx.de>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <200804041137.40582.rjw@sisk.pl> <20080406214333.GH30987@cs181133002.pp.htv.fi>
In-Reply-To: <20080406214333.GH30987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804062359.17915.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of April 2008, Adrian Bunk wrote:
> On Fri, Apr 04, 2008 at 11:37:40AM +0200, Rafael J. Wysocki wrote:
> > On Friday, 4 of April 2008, Adrian Bunk wrote:
> > > On Fri, Apr 04, 2008 at 01:20:32AM +0200, Rafael J. Wysocki wrote:
> > > > The following report is on the current list of known regressions
> > > > from 2.6.24.  Please verify if the issue is still present in the
> > > > mainline.
> > > 
> > > When you asked me just 2 days ago exactly the same question in the 
> > > Bugzilla entry I immediately confirmed it's still present.
> > > 
> > > Was anything wrong with my answer (and the subsequent discussions) that 
> > > you now also ask Toralf for confirmation?
> > 
> > This text is automatically added to the messages sent in replies to the main
> > report.
> > 
> > Well, it probably could be better.  I'm open for suggestions. :-)
> 
> First of all you try to get the tracking of all bugs into Bugzilla, and 
> now you've sent a batch of emails where the answers will not get into 
> Bugzilla automatically.

So?

> As an example, for the bug we are talking about the main value of you 
> asking me in Bugzilla was not that I confirmed it's still present, the 
> main value was that this caused Mauro to make a fix. What would have 
> happened if Toralf had answered in an email that the bug is still 
> present?

Most probably, I would add a reference to his reply to the bugzilla entry.

> And especially for trickier stuff like suspend/resume problems it might 
> also make sense to send the email to all people who might possibly be 
> involved with the bug - even if this means putting all email addresses 
> from 5 MAINTAINERS entries into one email. It takes a bit more time when 
> writing the emails, but my experience was it's worth it.

Yes, I'm going to do that in the future.

Thanks,
Rafael
