Return-Path: <linux-kernel-owner+w=401wt.eu-S1759559AbZDQBaT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759559AbZDQBaT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 21:30:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758283AbZDQB34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 21:29:56 -0400
Received: from mga09.intel.com ([134.134.136.24]:5017 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247AbZDQB3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 21:29:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,201,1239001200"; 
   d="scan'208";a="403892663"
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
From: Zhang Rui <rui.zhang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
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
In-Reply-To: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
Content-Type: text/plain
Date: Fri, 17 Apr 2009 09:30:13 +0800
Message-Id: <1239931813.7661.394.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-17 at 05:42 +0800, Rafael J. Wysocki wrote:
> 
> 
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13095
> Subject         : thinkpad-acpi: cannot control brightness with hotkeys
> Submitter       : Niel Lambrechts <niel.lambrechts@gmail.com>
> Date            : 2009-04-11 23:07 (6 days old)
> References      : http://lkml.org/lkml/2009/4/11/160
> Handled-By      : Matthew Garrett <mjg59@srcf.ucam.org>
> Patch           : http://lkml.org/lkml/2009/4/15/339
> 
> 
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13048
> Subject         : /sys/class/backlight/acpi_video0/* is gone on vaio laptop with Intel GM45.
> Submitter       : Rodrigo L. Batista <rodrigo@gus-mg.org>
> Date            : 2009-04-09 04:57 (8 days old)
> Handled-By      : yakui_zhao <yakui.zhao@intel.com>
> Patch           : http://bugzilla.kernel.org/attachment.cgi?id=20967
>                   http://bugzilla.kernel.org/attachment.cgi?id=20959
> 
> 
bug 13095 is a duplicate of bug 13048.
patches from Matthew and Yakui are for the same issue.

Yakui, could you verify which patch should be taken please?

thanks,
rui

