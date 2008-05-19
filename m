Return-Path: <linux-kernel-owner+w=401wt.eu-S1759702AbYESOlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759702AbYESOlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 10:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754709AbYESOli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 10:41:38 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37368 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756727AbYESOlh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 10:41:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Re: [Bug #10641] [BUG] 2.6.26-rc1-git4 - task blocked on powerpc for more than 120 seconds
Date: Mon, 19 May 2008 16:42:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nadia.Derbey@bull.net, bunk@kernel.org
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik> <7wuznNhcUqC.A.FEB.MtBMIB@albercik> <483127B9.3010205@linux.vnet.ibm.com>
In-Reply-To: <483127B9.3010205@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805191642.09583.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 of May 2008, Kamalesh Babulal wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10641
> > Subject		: [BUG] 2.6.26-rc1-git4 - task blocked on powerpc for more than 120 seconds
> > Submitter	: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> > Date		: 2008-05-07 13:34 (12 days old)
> > References	: http://marc.info/?l=linux-kernel&amp;m=121016673607188&amp;w=2
> > 
> 
> This bug seems to be because of the LTP version used, as pointed by Nadia. Using the
> latest LTP (2008-04-30), does not produces the calltraces mentioned in the bug. 

The bug has been closed already.

Thanks,
Rafael
