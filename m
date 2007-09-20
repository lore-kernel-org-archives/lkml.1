Return-Path: <linux-kernel-owner+w=401wt.eu-S1762257AbXITITP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762257AbXITITP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 04:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760896AbXITIR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 04:17:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:47098 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762195AbXITIRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 04:17:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,277,1186383600"; 
   d="scan'208";a="282799686"
Subject: Re: [RFC][PATCH 2/2 -mm] kexec based hibernation -v3: kexec restore
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20070920081524.GA8732@atrey.karlin.mff.cuni.cz>
References: <1190266450.21818.18.camel@caritas-dev.intel.com>
	 <20070920081524.GA8732@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 20 Sep 2007 16:19:41 +0800
Message-Id: <1190276381.21818.21.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
X-OriginalArrivalTime: 20 Sep 2007 08:17:42.0140 (UTC) FILETIME=[B72373C0:01C7FB5E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 10:15 +0200, Pavel Machek wrote:
> > This patch adds writing support for /dev/oldmem. This is used to
> > restore the memory contents of hibernated system.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> ACK. (And this can even go in before the patch #1, right?)

Yes. This patch does not depend on patch #1.

Best Regards,
Huang Ying
