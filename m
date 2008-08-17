Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYHQMTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYHQMTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYHQMTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:19:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39762 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbYHQMTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:19:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [Bug #11278] 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
Date: Sun, 17 Aug 2008 14:22:40 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Grant Coady <grant_lkml@dodo.com.au>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.i3F.PbzpIB@albercik> <1218960469.10800.259.camel@twins>
In-Reply-To: <1218960469.10800.259.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171422.41208.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Peter Zijlstra wrote:
> On Sat, 2008-08-16 at 21:02 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11278
> > Subject		: 2.6.27-rc2: Very odd top: '5124095h kthreadd' display
> > Submitter	: Grant Coady <grant_lkml@dodo.com.au>
> > Date		: 2008-08-07 7:03 (10 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121809267318795&w=4
> > Handled-By	: Peter Zijlstra <peterz@infradead.org>
> 
> 
> Should be fixed by: e26b33e9552c29c1d3fe67dc602c6264c29f5dc7

Thanks, closed.

Rafael
