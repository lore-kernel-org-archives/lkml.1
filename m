Return-Path: <linux-kernel-owner+w=401wt.eu-S932521AbZHUQpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbZHUQpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 12:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932321AbZHUQpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 12:45:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43107 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932313AbZHUQpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 12:45:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: [Bug #13947] Libertas: Association request to the driver failed
Date: Fri, 21 Aug 2009 18:46:07 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: roel kluin <roel.kluin@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <200908201710.32147.rjw@sisk.pl> <1250868934.2505.46.camel@localhost.localdomain>
In-Reply-To: <1250868934.2505.46.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <200908211846.07750.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 August 2009, Dan Williams wrote:
> On Thu, 2009-08-20 at 17:10 +0200, Rafael J. Wysocki wrote:
> > On Thursday 20 August 2009, roel kluin wrote:
> > > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13947
> > > > Subject         : Libertas: Association request to the driver failed
> > > > Submitter       : Daniel Mack <daniel@caiaq.de>
> > > > Date            : 2009-08-07 19:11 (13 days old)
> > > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
> > > > References      : http://marc.info/?l=linux-kernel&m=124967234311481&w=4
> > > > Handled-By      : Roel Kluin <roel.kluin@gmail.com>
> > > 
> > > I think this should be fixed with patch of Dan Williams found here:
> > > 
> > > http://lkml.org/lkml/2009/8/12/299
> > 
> > Thanks, bug entry updated.
> 
> Rebased tested and posted to linux-wireless officially:
> 
> Subject: [PATCH] libertas: clean up and clarify get_common_rates
> Date:    Fri, 21 Aug 2009 09:35:20 -0500

Thanks, updated.

Rafael
