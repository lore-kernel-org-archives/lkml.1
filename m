Return-Path: <linux-kernel-owner+w=401wt.eu-S1754724AbYHLOzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbYHLOzy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 10:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752480AbYHLOzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 10:55:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33154 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYHLOzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 10:55:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andy Whitcroft <apw@shadowen.org>
Subject: Re: [Bug #11275] [BUG] hugetlb: sleeping function called from invalid context
Date: Tue, 12 Aug 2008 16:58:50 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.Fm.6CjnIB@albercik> <20080812144841.GA16724@brain>
In-Reply-To: <20080812144841.GA16724@brain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808121658.51411.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 12 of August 2008, Andy Whitcroft wrote:
> On Sun, Aug 10, 2008 at 12:43:51AM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11275
> > Subject		: [BUG] hugetlb: sleeping function called from invalid context
> > Submitter	: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > Date		: 2008-08-06 14:43 (4 days old)
> > References	: http://marc.info/?l=linux-mm&m=121803401427843&w=4
> > Handled-By	: Andy Whitcroft <apw@shadowen.org>
> > Patch		: http://marc.info/?l=linux-kernel&m=121804949526359&w=4
> 
> This patch was superceeded by a newer version:
> 	http://marc.info/?l=linux-kernel&m=121819389913563&w=2
> 
> Currently this is in -mm, awaiting merge.

I have updated the Bugzilla entry with the current patch link.

Thanks,
Rafael
