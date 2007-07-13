Return-Path: <linux-kernel-owner+w=401wt.eu-S936247AbXGMJVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936247AbXGMJVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 05:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761026AbXGMJVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 05:21:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:18020 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755948AbXGMJVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 05:21:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,536,1175497200"; 
   d="scan'208";a="267813823"
Subject: Re: [PATCH 2/2] Kexec jump: Kexec jump
From: "Huang, Ying" <ying.huang@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>, nigel@nigel.suspend2.net,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <200707122158.39024.rjw@sisk.pl>
References: <1184167836.12556.15.camel@caritas-dev.intel.com>
	 <200707122158.39024.rjw@sisk.pl>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jul 2007 17:20:23 +0000
Message-Id: <1184347223.4523.22.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 13 Jul 2007 09:21:05.0268 (UTC) FILETIME=[2379FB40:01C7C52F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 21:58 +0200, Rafael J. Wysocki wrote:

> I know a little about kexec.
> 
> Could you please tell me what I should know/read to understand this patch?
> 

It is sufficient to read the kernel/kexec.c,
arch/i386/kernel/machine_kexec.c and arch/i386/kernel/relocate_kernel.S.

Best Regards,
Huang Ying
