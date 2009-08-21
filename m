Return-Path: <linux-kernel-owner+w=401wt.eu-S1755669AbZHUPfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755669AbZHUPfb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 11:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZHUPfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 11:35:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbZHUPfa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 11:35:30 -0400
Subject: Re: [Bug #13947] Libertas: Association request to the driver failed
From: Dan Williams <dcbw@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: roel kluin <roel.kluin@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200908201710.32147.rjw@sisk.pl>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera>
	 <ADSuNT6McuD.A.fc.7NIjKB@chimera>
	 <25e057c00908200151i472fa3cem6da814e7115e1ea7@mail.gmail.com>
	 <200908201710.32147.rjw@sisk.pl>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 10:35:34 -0500
Message-Id: <1250868934.2505.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-08-20 at 17:10 +0200, Rafael J. Wysocki wrote:
> On Thursday 20 August 2009, roel kluin wrote:
> > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13947
> > > Subject         : Libertas: Association request to the driver failed
> > > Submitter       : Daniel Mack <daniel@caiaq.de>
> > > Date            : 2009-08-07 19:11 (13 days old)
> > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
> > > References      : http://marc.info/?l=linux-kernel&m=124967234311481&w=4
> > > Handled-By      : Roel Kluin <roel.kluin@gmail.com>
> > 
> > I think this should be fixed with patch of Dan Williams found here:
> > 
> > http://lkml.org/lkml/2009/8/12/299
> 
> Thanks, bug entry updated.

Rebased tested and posted to linux-wireless officially:

Subject: [PATCH] libertas: clean up and clarify get_common_rates
Date:    Fri, 21 Aug 2009 09:35:20 -0500

Dan


