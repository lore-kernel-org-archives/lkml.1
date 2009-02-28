Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbZB1WAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbZB1WAv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 17:00:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753990AbZB1WAn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 17:00:43 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49557 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753518AbZB1WAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 17:00:42 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [Bug #12762] Disk errors loop forever in 2.6.29
Date: Sat, 28 Feb 2009 23:00:10 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera> <vP9hdyF4fL.A.dKD.3ozoJB@chimera> <20090228215027.GA22913@silver.sucs.org>
In-Reply-To: <20090228215027.GA22913@silver.sucs.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902282300.11455.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 28 February 2009, Sitsofe Wheeler wrote:
> On Mon, Feb 23, 2009 at 10:48:17PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12762
> > Subject		: Disk errors loop forever in 2.6.29
> > Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
> > Date		: 2009-02-19 13:53 (5 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b60af5b0adf0da24c673598c8d3fb4d4189a15ce
> > References	: http://marc.info/?l=linux-kernel&m=123505185407604&w=4
> > Handled-By	: James Bottomley <James.Bottomley@hansenpartnership.com>
> > Patch		: http://marc.info/?l=linux-kernel&m=123508030726900&w=4
> 
> Sorry I wasn't paying enough attention (am I going to get this message
> for every rc?).

Yes (this is because the bug is on the list of recent regressions), but
generally you don't need to reply to it every time. :-)

> Yes this still happens in 2.6.29-rc6.

Thanks for the update.

Rafael
