Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517AbYKKQd5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517AbYKKQd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:33:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751172AbYKKQds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:33:48 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:54179 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYKKQdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:33:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mike Isely <isely@pobox.com>
Subject: Re: [Bug #11829] Kernel 2.6.26.5 -&gt; 2.6.27.2 [USB REGRESSION] (USB -&gt; D_STATE)
Date: Tue, 11 Nov 2008 17:38:20 +0100
User-Agent: KMail/1.9.9
Cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera> <200811111453.34386.rjw@sisk.pl> <Pine.LNX.4.64.0811110938500.22093@cnc.isely.net>
In-Reply-To: <Pine.LNX.4.64.0811110938500.22093@cnc.isely.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811111738.20759.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 11 of November 2008, Mike Isely wrote:
> On Tue, 11 Nov 2008, Rafael J. Wysocki wrote:
> 
> > On Tuesday, 11 of November 2008, Greg KH wrote:
> > > On Sun, Nov 09, 2008 at 08:43:22PM +0100, Rafael J. Wysocki wrote:
> > > > This message has been generated automatically as a part of a report
> > > > of regressions introduced between 2.6.26 and 2.6.27.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > > > be listed and let me know (either way).
> > > > 
> > > > 
> > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11829
> > > > Subject		: Kernel 2.6.26.5 -&gt; 2.6.27.2 [USB REGRESSION] (USB -&gt; D_STATE)
> > > > Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
> > > > Date		: 2008-10-19 11:26 (22 days old)
> > > > References	: http://marc.info/?l=linux-kernel&m=122441560120027&w=4
> > > > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > > > 		  Mike Isely <isely@isely.net>
> > > > Patch		: http://linuxtv.org/hg/~mcisely/pvrusb2/rev/0bb411d8d2e4
> > > 
> > > This has been fixed already in .27 and in mainline with a patch from
> > > Alan.
> > 
> > OK, closed it.
> > 
> > Do you remember which of the Alan's patches is that?
> 
> It wasn't a patch from Alan.  It was from me.  The commit ID is 
> c82732a42896364296599b0f73f01c5e3fd781ae

OK, thanks.

I added the "Fixed by" information to the bug entry, for the record.

Rafael
