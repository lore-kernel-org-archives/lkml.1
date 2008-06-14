Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbYFNXiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbYFNXiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2008 19:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755656AbYFNXiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jun 2008 19:38:15 -0400
Received: from gate.crashing.org ([63.228.1.57]:42674 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbYFNXiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2008 19:38:14 -0400
Subject: Re: [Bug 10714] Badness seen on 2.6.26-rc2 with lockdep enabled
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Adrian Bunk <bunk@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, linuxppc-dev@ozlabs.org,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <20080614230424.GA21168@cs181133002.pp.htv.fi>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	 <Jn7irxIunJK.A.ggF.4KDVIB@albercik>
	 <20080614230424.GA21168@cs181133002.pp.htv.fi>
Content-Type: text/plain
Date: Sun, 15 Jun 2008 09:29:21 +1000
Message-Id: <1213486161.8129.89.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-15 at 02:04 +0300, Adrian Bunk wrote:
> On Sat, Jun 14, 2008 at 10:12:02PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10714
> > Subject		: Badness seen on 2.6.26-rc2 with lockdep enabled
> > Submitter	: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Date		: 2008-05-14 12:57 (32 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121076917429133&w=4
> 
> Benjamin, you said you wanted to have a look at this?

Ah yes, slipped out of my mind. It's probably a missing annotation in
the RTAS code, I'll have a look tomorrow.

Thanks,
Ben.


