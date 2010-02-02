Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab0BBUl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 15:41:28 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36302 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988Ab0BBUlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 15:41:25 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michael Breuer <mbreuer@majjas.com>
Subject: Re: [Bug #15125] hung task - jbd2/dm-1-8 (during raid rebuild)
Date: Tue, 2 Feb 2010 21:42:20 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <vZZJKzCUn4G.A.CPB.F7hZLB@chimera> <4B662358.7020603@majjas.com> <4B6711D0.4060300@majjas.com>
In-Reply-To: <4B6711D0.4060300@majjas.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201002022142.20684.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 February 2010, Michael Breuer wrote:
> On 1/31/2010 7:42 PM, Michael Breuer wrote:
> > On 1/31/2010 7:22 PM, Rafael J. Wysocki wrote:
> >> This message has been generated automatically as a part of a report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.32.  Please verify if it still should be listed and let me know
> >> (either way).
> >>
> >>
> >> Bug-Entry    : http://bugzilla.kernel.org/show_bug.cgi?id=15125
> >> Subject        : hung task - jbd2/dm-1-8 (during raid rebuild)
> >> Submitter    : Michael Breuer<mbreuer@majjas.com>
> >> Date        : 2010-01-10 21:47 (22 days old)
> >> References    : http://marc.info/?l=linux-kernel&m=126316012025978&w=4
> >>
> > Yup. Hit it again on 2.6.33-rc5.
> I was not able to recreate this in rc6.

Thanks, closed then.

Rafael
