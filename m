Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbYLHHCq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbYLHHCq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 02:02:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYLHHCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 02:02:36 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:52374 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbYLHHCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 02:02:35 -0500
Date: Mon, 8 Dec 2008 12:32:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [Bug #12177] [memcg BUG ?] failed to boot on IA64 with
	CONFIG_DISCONTIGMEM=y
Message-ID: <20081208070230.GA18939@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Li Zefan <lizf@cn.fujitsu.com>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera> <07Xes05z25M.A.b-E.SsEPJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <07Xes05z25M.A.b-E.SsEPJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael J. Wysocki <rjw@sisk.pl> [2008-12-07 21:32:57]:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12177
> Subject		: [memcg BUG ?] failed to boot on IA64 with CONFIG_DISCONTIGMEM=y
> Submitter	: Li Zefan <lizf@cn.fujitsu.com>
> Date		: 2008-12-05 3:09 (3 days old)
> References	: http://marc.info/?l=linux-kernel&m=122844668532752&w=4
> Handled-By	: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Patch		: http://marc.info/?l=linux-kernel&m=122844757701505&w=4

Kamezawa has a fix that Li has tested. We need to polish the changelog
and resend the patch.

-- 
	Balbir
