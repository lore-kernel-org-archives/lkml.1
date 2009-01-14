Return-Path: <linux-kernel-owner+w=401wt.eu-S1759109AbZANHjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759109AbZANHjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 02:39:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755349AbZANHi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 02:38:57 -0500
Received: from mail.gmx.net ([213.165.64.20]:45229 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754426AbZANHiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 02:38:55 -0500
X-Authenticated: #23875046
X-Provags-ID: V01U2FsdGVkX19l88B1ReJlj2vZbZo1hDGdjjAk3dw1t1dhwT/Ky2
	3uqy09qhULFtNy
Message-ID: <496D968C.4050405@fisher-privat.net>
Date: Wed, 14 Jan 2009 08:38:52 +0100
From: Alexey Fisher <bug-track@fisher-privat.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [Bug #12417] glx performance drop with: "x86: PAT: implement
 track/untrack of pfnmap regions for x86 - v3"
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <oWTznAnH9BI.A.dnH.OHfaJB@chimera>
In-Reply-To: <oWTznAnH9BI.A.dnH.OHfaJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki schrieb:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12417
> Subject		: glx performance drop with: "x86: PAT: implement track/untrack of pfnmap regions for x86 - v3"
> Submitter	: Alexey Fisher <bug-track@fisher-privat.net>
> Date		: 2009-01-06 18:46 (6 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=5899329b19100c0b82dc78e9b21ed8b920c9ffb3
> References	: http://marc.info/?l=linux-kernel&m=123126782822696&w=4
> Handled-By	: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-testers" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

There is no more warnings on the xorg start, but x server will completly
freeze on glxgears.
