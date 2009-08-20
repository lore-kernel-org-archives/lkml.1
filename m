Return-Path: <linux-kernel-owner+w=401wt.eu-S1754647AbZHTPJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbZHTPJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 11:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZHTPJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 11:09:39 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38330 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313AbZHTPJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 11:09:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: roel kluin <roel.kluin@gmail.com>
Subject: Re: [Bug #13947] Libertas: Association request to the driver failed
Date: Thu, 20 Aug 2009 17:10:32 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Daniel Mack <daniel@caiaq.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Dan Williams <dcbw@redhat.com>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.fc.7NIjKB@chimera> <25e057c00908200151i472fa3cem6da814e7115e1ea7@mail.gmail.com>
In-Reply-To: <25e057c00908200151i472fa3cem6da814e7115e1ea7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908201710.32147.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, roel kluin wrote:
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13947
> > Subject         : Libertas: Association request to the driver failed
> > Submitter       : Daniel Mack <daniel@caiaq.de>
> > Date            : 2009-08-07 19:11 (13 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=57921c312e8cef72ba35a4cfe870b376da0b1b87
> > References      : http://marc.info/?l=linux-kernel&m=124967234311481&w=4
> > Handled-By      : Roel Kluin <roel.kluin@gmail.com>
> 
> I think this should be fixed with patch of Dan Williams found here:
> 
> http://lkml.org/lkml/2009/8/12/299

Thanks, bug entry updated.

Rafael
