Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbZCDBDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbZCDBDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 20:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZCDBD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 20:03:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:3794 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbZCDBDZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 20:03:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,297,1233561600"; 
   d="scan'208";a="494714597"
Subject: Re: 2.6.29-rc6-git7: Reported regressions from 2.6.28
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
In-Reply-To: <KiHv0irKPzE.A.l3.hUarJB@chimera>
References: <KiHv0irKPzE.A.l3.hUarJB@chimera>
Content-Type: text/plain
Date: Wed, 04 Mar 2009 09:03:46 +0800
Message-Id: <1236128626.32297.254.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-04 at 03:22 +0800, Rafael J. Wysocki wrote:
> 
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=12501
> Subject         : build bug in eeepc-laptop.c
> Submitter       : Ingo Molnar <mingo@elte.hu>
> Date            : 2009-01-14 17:25 (49 days old)
> References      : http://lkml.org/lkml/2009/1/14/315
> 
the problem has already been fixed by
3a5093ee6728c8cbe9c039e685fc1fca8f965048

thanks,
rui

