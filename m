Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbYHLRQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbYHLRQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 13:16:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYHLRQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 13:16:40 -0400
Received: from mail.gmx.net ([213.165.64.20]:45851 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752177AbYHLRQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 13:16:39 -0400
X-Authenticated: #704063
X-Provags-ID: V01U2FsdGVkX18JlCks4/IJOHgCjPAP2pSn6qMBoL6wySKTcWOYwm
	2/bJ9kUdL3m/Lb
Date: Tue, 12 Aug 2008 19:16:35 +0200
From: Eric Sesterhenn <snakebyte@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Rabin Vincent <rabin@rab.in>
Subject: Re: [Bug #11274] Oops when accessing /proc/lockdep_chains
Message-ID: <20080812171635.GA18689@alice>
References: <VYYCiQF4qDI.A.BPH.KCjnIB@albercik> <cX_-nNkxKaF.A.Ks.8CjnIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cX_-nNkxKaF.A.Ks.8CjnIB@albercik>
X-Editor: Vim http://www.vim.org/
X-Info: http://www.snake-basket.de
X-Operating-System: Linux/2.6.27-rc2 (x86_64)
X-Uptime: 19:16:05 up 1 day,  6:06,  3 users,  load average: 0.00, 0.07,
	0.09
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki (rjw@sisk.pl) wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11274
> Subject		: Oops when accessing /proc/lockdep_chains
> Submitter	: Eric Sesterhenn <snakebyte@gmx.de>
> Date		: 2008-08-06 12:16 (4 days old)
> References	: http://marc.info/?l=linux-kernel&m=121802509626294&w=4
> Handled-By	: Rabin Vincent <rabin@rab.in>
> Patch		: http://marc.info/?l=linux-kernel&m=121814269607276&w=4

the patch went into linus -git today, you can close this.

Thanks, Eric

