Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0BOIeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 03:34:31 -0500
Received: from mail.gmx.net ([213.165.64.20]:40368 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752696Ab0BOIe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 03:34:29 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+RkLBJmV+RWERJOnOFUJY9DE2L6/skWuftEZ8P13
	c3LIW0ijf92Ipt
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15100] X11 is black after resume from s2ram if my T400 was previous in docking station before
Date: Mon, 15 Feb 2010 09:34:23 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12; KDE/4.3.5; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       "Eric Anholt" <eric@anholt.net>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Matthew Garrett" <mjg@redhat.com>
References: <fQEllunEdO.A.-LB.HyIeLB@chimera> <Xv2rBFCTXTH.A.8LC.ryIeLB@chimera>
In-Reply-To: <Xv2rBFCTXTH.A.8LC.ryIeLB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201002150934.23888.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Rafael J. Wysocki wrote at 00:52:50
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.31 and 2.6.32.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15100
> Subject		: X11 is black after resume from s2ram if my T400 was previous in
>  docking station before Submitter	: Toralf Förster <toralf.foerster@gmx.de>
> Date		: 2010-01-21 08:56 (25 days old)
> First-Bad-Commit:
>  http://git.kernel.org/git/linus/c1c7af60892070e4b82ad63bbfb95ae745056de0
> 
Issue present in 2.6.33-rc8

-- 
MfG/Sincerely
Toralf Förster
