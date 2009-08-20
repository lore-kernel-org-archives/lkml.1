Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZHTO5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZHTO5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 10:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754334AbZHTO5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 10:57:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38257 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbZHTO5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 10:57:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: [Bug #13899] Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
Date: Thu, 20 Aug 2009 16:58:21 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <jCYznkTxcLB.A.EPH.eNIjKB@chimera> <ADSuNT6McuD.A.-IB.NOIjKB@chimera> <200908192251.39372.gene.heskett@verizon.net>
In-Reply-To: <200908192251.39372.gene.heskett@verizon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200908201658.21930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 August 2009, Gene Heskett wrote:
> On Wednesday 19 August 2009, Rafael J. Wysocki wrote:
> >This message has been generated automatically as a part of a report
> >of recent regressions.
> >
> >The following bug entry is on the current list of known regressions
> >from 2.6.30.  Please verify if it still should be listed and let me know
> >(either way).
> >
> >
> >Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13899
> >Subject		: Oops from tar, 2.6.31-rc5, 32 bit on quad core phenom.
> >Submitter	: Gene Heskett <gene.heskett@verizon.net>
> >Date		: 2009-08-01 13:04 (19 days old)
> >References	: http://marc.info/?l=linux-kernel&m=124913190304149&w=4
> 
> I have not seen this since I rebooted to 31-rc6 3.5 days ago.  So apparently 
> something that went into rc6 that was not in rc5, has fixed it.  I have had 
> one kmail crash, but IIRC that was after yum had updated something.  I 
> believe this particular tar related  item has been attended to.  Close it 
> out.

Thanks, closed.

Rafael
