Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbYDENGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbYDENGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Apr 2008 09:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYDENGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Apr 2008 09:06:03 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:58307 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbYDENGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Apr 2008 09:06:01 -0400
Date: Sat, 5 Apr 2008 10:05:20 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Ray Lee <ray-lk@madrabbit.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Soeren Sonnenburg <kernel@nn7.de>
Subject: Re: 2.6.25-current-git hangs on boot unless CONFIG_CPU_IDLE=n-Apple
Message-ID: <20080405130520.GA8959@localhost.ift.unesp.br>
References: <pdj7pZVURbL.A.42H.kDW9HB@albercik> <pdYe6zNQVl.A.AOB.6GW9HB@albercik> <924EFEDD5F540B4284297C4DC59F3DEED0EA1E@orsmsx423.amr.corp.intel.com> <20080404011053.GA21254@localhost.ift.unesp.br> <2c0942db0804032015y57e91811r37b729cd836cef6d@mail.gmail.com> <20080404114756.GA3890@localhost.ift.unesp.br> <924EFEDD5F540B4284297C4DC59F3DEED0EB77@orsmsx423.amr.corp.intel.com> <20080404155155.GA6578@localhost.ift.unesp.br> <924EFEDD5F540B4284297C4DC59F3DEED0EEC6@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEED0EEC6@orsmsx423.amr.corp.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri  4.Apr'08 at 13:41:45 -0700, Pallipadi, Venkatesh wrote:

> >>> Can you try the latest git and see whether this still is a problem?
> >>
> >>I've just updated to latest git, but it may take some time for it 
> >>to happen again (the first 3 boots were okay). Last time it happened
> >>with 2.6.25-rc7-00149-gaf8be4e (I checked now). 
> >>
> >>Do you have reasons to believe this issue was fixed since then?
> >
> >Yes. I think the patch here should have fixed the problem....
> >Patch : http://marc.info/?l=linux-kernel&m=120674502201007&w=4
> >
> 
> Hmmmm.... Looking at latest git,
> The above patch is not yet in git. Can you please apply the above patch
> and see whether do you still see the problem.....

OK, I will apply it manually and test it.

For the record: yesterday my laptop hang at boot with v2.6.25-rc8-139-ge315c12
(without the above patch).

