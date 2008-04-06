Return-Path: <linux-kernel-owner+w=401wt.eu-S1756458AbYDFVBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756458AbYDFVBn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 17:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYDFVBg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 17:01:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50536 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752808AbYDFVBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 17:01:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Subject: Re: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
Date: Sun, 6 Apr 2008 23:01:50 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <924EFEDD5F540B4284297C4DC59F3DEED0EEC6@orsmsx423.amr.corp.intel.com> <20080405130520.GA8959@localhost.ift.unesp.br>
In-Reply-To: <20080405130520.GA8959@localhost.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804062301.51490.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of April 2008, Carlos R. Mafra wrote:
> On Fri  4.Apr'08 at 13:41:45 -0700, Pallipadi, Venkatesh wrote:
> 
> > >>> Can you try the latest git and see whether this still is a problem?
> > >>
> > >>I've just updated to latest git, but it may take some time for it 
> > >>to happen again (the first 3 boots were okay). Last time it happened
> > >>with 2.6.25-rc7-00149-gaf8be4e (I checked now). 
> > >>
> > >>Do you have reasons to believe this issue was fixed since then?
> > >
> > >Yes. I think the patch here should have fixed the problem....
> > >Patch : http://marc.info/?l=linux-kernel&m=120674502201007&w=4
> > >
> > 
> > Hmmmm.... Looking at latest git,
> > The above patch is not yet in git. Can you please apply the above patch
> > and see whether do you still see the problem.....
> 
> OK, I will apply it manually and test it.
> 
> For the record: yesterday my laptop hang at boot with v2.6.25-rc8-139-ge315c12
> (without the above patch).

Carlos, please add yourself to the CC list at
http://bugzilla.kernel.org/show_bug.cgi?id=10093

Thanks,
Rafael
