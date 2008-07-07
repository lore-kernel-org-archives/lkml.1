Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYGGW2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYGGW2c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 18:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbYGGW2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 18:28:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35130 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbYGGW2X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 18:28:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [Bug #11025] [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86 (bisected)
Date: Tue, 8 Jul 2008 00:30:19 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Dan Williams <dan.j.williams@intel.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.z4.WzLcIB@albercik> <20080707161620.GA30381@csn.ul.ie>
In-Reply-To: <20080707161620.GA30381@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807080030.20347.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of July 2008, Mel Gorman wrote:
> On (06/07/08 13:45), Rafael J. Wysocki didst pronounce:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11025
> > Subject		: [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86 (bisected)
> > Submitter	: Dan Williams <dan.j.williams@intel.com>
> > Date		: 2008-07-01 1:57 (6 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121487749429883&w=4
> > Handled-By	: Mel Gorman <mel@csn.ul.ie>
> > 		  Andy Whitcroft <apw@shadowen.org>
> > 
> 
> Fixed by commit 494de90098784b8e2797598cefdd34188884ec2e and should be
> closed.

Already closed.

Thanks,
Rafael
