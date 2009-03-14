Return-Path: <linux-kernel-owner+w=401wt.eu-S1758423AbZCNWFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758423AbZCNWFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 18:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758130AbZCNWEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 18:04:49 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:37894 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759210AbZCNWEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 18:04:47 -0400
Message-ID: <49BC29FA.1060308@mandriva.org>
Date: Sun, 15 Mar 2009 00:04:42 +0200
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090314)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       John Dykstra <john.dykstra1@gmail.com>
Subject: Re: [Bug #12869] BUG when disabled ipv6 module is unloaded
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.DjC.O4BvJB@chimera>
In-Reply-To: <GCLaknAim2M.A.DjC.O4BvJB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki skrev:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12869
> Subject		: BUG when disabled ipv6 module is unloaded
> Submitter	: Thomas Backlund <tmb@mandriva.org>
> Date		: 2009-03-10 20:15 (5 days old)
> References	: http://marc.info/?l=linux-kernel&m=123671614621097&w=4
> Handled-By	: John Dykstra <john.dykstra1@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&m=123672746905127&w=4
> 
> 

Yeah, sorry for the delay testing it...

I confirm the bug is fixed with the above patch...

--
Thomas
