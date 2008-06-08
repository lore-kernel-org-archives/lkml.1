Return-Path: <linux-kernel-owner+w=401wt.eu-S1757417AbYFHQuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417AbYFHQuQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 12:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYFHQuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 12:50:05 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42011 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755564AbYFHQuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 12:50:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: [Bug #10761] hackbench regression with 2.6.26-rc2 on tulsa machine
Date: Sun, 8 Jun 2008 18:51:12 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
References: <GIilET9wkhI.A.JzB.81vSIB@albercik> <dCRO4tbfLzK.A.hBE.o3vSIB@albercik> <1212896711.4927.6.camel@marge.simson.net>
In-Reply-To: <1212896711.4927.6.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081851.13109.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 8 of June 2008, Mike Galbraith wrote:
> 
> On Sat, 2008-06-07 at 22:42 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10761
> > Subject		: hackbench regression with 2.6.26-rc2 on tulsa machine
> > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > Date		: 2008-05-20 8:09 (19 days old)
> > References	: http://marc.info/?l=linux-kernel&amp;m=121127121813708&amp;w=2
> > 		  http://lkml.org/lkml/2008/6/2/10
> > Handled-By	: Mike Galbraith <efault@gmx.de>
> 
> The fingered patchlet and the code it touched were reverted, so I think
> this is a stale entry.

Thanks, closed.

Rafael
