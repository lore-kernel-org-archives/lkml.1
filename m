Return-Path: <linux-kernel-owner+w=401wt.eu-S1762083AbZDQVfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbZDQVfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 17:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZDQVfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 17:35:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43063 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbZDQVfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 17:35:38 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Zhang Rui <rui.zhang@intel.com>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
Date: Fri, 17 Apr 2009 23:35:27 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2-rjw; KDE/4.2.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera> <1239931813.7661.394.camel@rzhang-dt>
In-Reply-To: <1239931813.7661.394.camel@rzhang-dt>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904172335.28304.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 April 2009, Zhang Rui wrote:
> On Fri, 2009-04-17 at 05:42 +0800, Rafael J. Wysocki wrote:
> > 
> > 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13095
> > Subject         : thinkpad-acpi: cannot control brightness with hotkeys
> > Submitter       : Niel Lambrechts <niel.lambrechts@gmail.com>
> > Date            : 2009-04-11 23:07 (6 days old)
> > References      : http://lkml.org/lkml/2009/4/11/160
> > Handled-By      : Matthew Garrett <mjg59@srcf.ucam.org>
> > Patch           : http://lkml.org/lkml/2009/4/15/339
> > 
> > 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13048
> > Subject         : /sys/class/backlight/acpi_video0/* is gone on vaio laptop with Intel GM45.
> > Submitter       : Rodrigo L. Batista <rodrigo@gus-mg.org>
> > Date            : 2009-04-09 04:57 (8 days old)
> > Handled-By      : yakui_zhao <yakui.zhao@intel.com>
> > Patch           : http://bugzilla.kernel.org/attachment.cgi?id=20967
> >                   http://bugzilla.kernel.org/attachment.cgi?id=20959
> > 
> > 
> bug 13095 is a duplicate of bug 13048.
> patches from Matthew and Yakui are for the same issue.

OK, closed 13095 as a duplicate.

Thanks,
Rafael
