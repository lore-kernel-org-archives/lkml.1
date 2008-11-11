Return-Path: <linux-kernel-owner+w=401wt.eu-S1753852AbYKKQnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbYKKQnR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 11:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYKKQm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 11:42:58 -0500
Received: from netrider.rowland.org ([192.131.102.5]:1643 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751458AbYKKQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 11:42:57 -0500
Date: Tue, 11 Nov 2008 11:42:56 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Greg KH <greg@kroah.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, Mike Isely <isely@isely.net>
Subject: Re: [Bug #11829] Kernel 2.6.26.5 -&gt; 2.6.27.2 [USB REGRESSION]
 (USB -&gt; D_STATE)
In-Reply-To: <200811111453.34386.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0811111141500.29125-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Rafael J. Wysocki wrote:

> On Tuesday, 11 of November 2008, Greg KH wrote:
> > On Sun, Nov 09, 2008 at 08:43:22PM +0100, Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of regressions introduced between 2.6.26 and 2.6.27.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> > > be listed and let me know (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11829
> > > Subject		: Kernel 2.6.26.5 -&gt; 2.6.27.2 [USB REGRESSION] (USB -&gt; D_STATE)
> > > Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
> > > Date		: 2008-10-19 11:26 (22 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=122441560120027&w=4
> > > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > > 		  Mike Isely <isely@isely.net>
> > > Patch		: http://linuxtv.org/hg/~mcisely/pvrusb2/rev/0bb411d8d2e4
> > 
> > This has been fixed already in .27 and in mainline with a patch from
> > Alan.
> 
> OK, closed it.
> 
> Do you remember which of the Alan's patches is that?

I wasn't one of mine.  The patch was written by Mike Isely: commit 
c82732a42896364296599b0f73f01c5e3fd781ae.

Alan Stern

