Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbZAKSnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbZAKSnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751679AbZAKSm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:42:56 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37968 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbZAKSmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:42:55 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: [Bug #12279] 2.6.28 suspend regression - HP 2510p
Date: Sun, 11 Jan 2009 19:42:34 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Roka" <roka@dawid.hu>
References: <nn3SOLVZ28H.A.bY.CafaJB@chimera> <nHCfeC0YLrE.A.1SC.wafaJB@chimera> <200901111703.24868.bzolnier@gmail.com>
In-Reply-To: <200901111703.24868.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111942.34899.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 11 January 2009, Bartlomiej Zolnierkiewicz wrote:
> On Sunday 11 January 2009, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.27 and 2.6.28.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12279
> > Subject		: 2.6.28 suspend regression - HP 2510p
> > Submitter	: David Roka <roka@dawid.hu>
> > Date		: 2008-12-23 04:17 (20 days old)
> > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4dde4492d850a4c9bcaa92e5bd7f4eebe3e2f5ab
> 
> The fix went in the first IDE updates pull for 2.6.29:
> 
> commit 0e63a588fc3d6a5e6bb66bacaeb11cd9093141f8
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Mon Dec 29 20:27:29 2008 +0100
> 
>     ide: fix IDE ACPI regression breaking suspend
> ...
> 
> so it can be marked as closed now.

Thanks for closing.

Best,
Rafael
