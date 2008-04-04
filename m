Return-Path: <linux-kernel-owner+w=401wt.eu-S1759319AbYDDJhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319AbYDDJhz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 05:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758583AbYDDJhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 05:37:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37517 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757544AbYDDJhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 05:37:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: TUNER_TDA8290=y, VIDEO_DEV=n build error
Date: Fri, 4 Apr 2008 11:37:40 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Toralf Feorster <toralf.foerster@gmx.de>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.iUB.YHW9HB@albercik> <20080404084754.GA10993@cs181133002.pp.htv.fi>
In-Reply-To: <20080404084754.GA10993@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804041137.40582.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 4 of April 2008, Adrian Bunk wrote:
> On Fri, Apr 04, 2008 at 01:20:32AM +0200, Rafael J. Wysocki wrote:
> > The following report is on the current list of known regressions
> > from 2.6.24.  Please verify if the issue is still present in the
> > mainline.
> 
> When you asked me just 2 days ago exactly the same question in the 
> Bugzilla entry I immediately confirmed it's still present.
> 
> Was anything wrong with my answer (and the subsequent discussions) that 
> you now also ask Toralf for confirmation?

This text is automatically added to the messages sent in replies to the main
report.

Well, it probably could be better.  I'm open for suggestions. :-)

> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10067
> > Subject		: TUNER_TDA8290=y, VIDEO_DEV=n build error
> > Submitter	: Toralf Foerster <toralf.foerster@gmx.de>
> > Date		: 2008-02-22 10:36 (42 days old)
> > References	: http://lkml.org/lkml/2008/2/19/262

Thanks,
Rafael
