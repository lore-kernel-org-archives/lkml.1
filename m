Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbYFEVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbYFEVL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757481AbYFEVLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:11:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56193 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721AbYFEVLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:11:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [Bug #10634] volanoMark regression with kernel 2.6.26-rc1
Date: Thu, 5 Jun 2008 23:11:50 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik> <20080531190247.GA4569@linux.vnet.ibm.com> <1212381479.3177.260.camel@ymzhang>
In-Reply-To: <1212381479.3177.260.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806052311.51468.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 2 of June 2008, Zhang, Yanmin wrote:
> 
> On Sun, 2008-06-01 at 00:32 +0530, Dhaval Giani wrote:
> > On Sat, May 31, 2008 at 07:48:05PM +0200, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.25.  Please verify if it still should be listed.
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10634
> > > Subject		: volanoMark regression with kernel 2.6.26-rc1
> > > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > > Date		: 2008-05-06 2:06 (26 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=121003968414287&w=2
> > > Handled-By	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> > > 		  Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > > 		  Ingo Molnar <mingo@elte.hu>
> > > 		  Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Patch		: http://marc.info/?l=linux-kernel&m=121015292616788&w=2
> > > 
> > 
> > Should have been fixed with 6363ca57c76b7b83639ca8c83fc285fa26a7880e
> > 
> > Yanmin, could you confirm please?
> Confirmed.

Thanks, closed.

Rafael
