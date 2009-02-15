Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbZBOEUt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbZBOEUt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 23:20:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZBOEUk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 23:20:40 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:44822 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788AbZBOEUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 23:20:39 -0500
Message-ID: <499797FD.5070701@lwfinger.net>
Date: Sat, 14 Feb 2009 22:20:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Hugh Dickins <hugh@veritas.com>,
       Mikael Pettersson <mikpe@it.uu.se>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [Bug #12609] v2.6.29-rc2 libata sff 32bit PIO regression
References: <juADNmcceYF.A.mdD.Mr0lJB@chimera> <rjPbZ5GRJPO.A.kkF.Ds0lJB@chimera>
In-Reply-To: <rjPbZ5GRJPO.A.kkF.Ds0lJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12609
> Subject		: v2.6.29-rc2 libata sff 32bit PIO regression
> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
> Date		: 2009-01-23 23:52 (23 days old)
> References	: http://marc.info/?l=linux-kernel&m=123275478111406&w=4
> 		  http://marc.info/?l=linux-kernel&m=123254501314058&w=4
> Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
> 		  Hugh Dickins <hugh@veritas.com>
> 		  Sergei Shtylyov <sshtylyov@ru.mvista.com>
> Patch		: http://marc.info/?l=linux-kernel&m=123412278730735&w=4

This problem is not fixed as of 2.6.29-rc5.

Larry
