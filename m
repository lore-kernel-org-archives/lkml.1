Return-Path: <linux-kernel-owner+w=401wt.eu-S1762000AbZBEBxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762000AbZBEBxn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754166AbZBEBxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:53:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49555 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350AbZBEBxc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:53:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [Bug #12611] kernel BUG at kernel/cgroup.c:398!
Date: Thu, 5 Feb 2009 02:53:14 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.TrD.quYiJB@chimera> <498A3AB7.9060701@cn.fujitsu.com>
In-Reply-To: <498A3AB7.9060701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050253.15025.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Li Zefan wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12611
> > Subject		: kernel BUG at kernel/cgroup.c:398!
> > Submitter	: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > Date		: 2009-01-28 15:49 (8 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123315721707796&w=4
> > 
> 
> It has been fixed by the following commit:
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=839ec5452ebfd5905b9c69b20ceb640903a8ea1a

Already closed.

Thanks,
Rafael
