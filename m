Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbYLHHaN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbYLHHaN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 02:30:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750800AbYLHH37
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 02:29:59 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36262 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYLHH36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 02:29:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: balbir@linux.vnet.ibm.com
Subject: Re: [Bug #12177] [memcg BUG ?] failed to boot on IA64 with CONFIG_DISCONTIGMEM=y
Date: Mon, 8 Dec 2008 08:29:22 +0100
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>
References: <6VnlupFpCsN.A.2rE.MsEPJB@chimera> <07Xes05z25M.A.b-E.SsEPJB@chimera> <20081208070230.GA18939@balbir.in.ibm.com>
In-Reply-To: <20081208070230.GA18939@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812080829.22352.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 8 of December 2008, Balbir Singh wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> [2008-12-07 21:32:57]:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.27.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12177
> > Subject		: [memcg BUG ?] failed to boot on IA64 with CONFIG_DISCONTIGMEM=y
> > Submitter	: Li Zefan <lizf@cn.fujitsu.com>
> > Date		: 2008-12-05 3:09 (3 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122844668532752&w=4
> > Handled-By	: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=122844757701505&w=4
> 
> Kamezawa has a fix that Li has tested. We need to polish the changelog
> and resend the patch.

Thanks for the update.

Rafael
