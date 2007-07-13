Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbXGMPTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbXGMPTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755822AbXGMPTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:19:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:62659 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522AbXGMPTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,537,1175497200"; 
   d="scan'208";a="267912172"
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base
	hibernation
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: nigel@nigel.suspend2.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <20070712085428.GA1866@elf.ucw.cz>
References: <1184167831.12556.13.camel@caritas-dev.intel.com>
	 <20070711111350.GI7091@elf.ucw.cz>
	 <1184257734.9346.76.camel@caritas-dev.intel.com>
	 <20070712085428.GA1866@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 13 Jul 2007 23:18:47 +0000
Message-Id: <1184368727.1069.71.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 13 Jul 2007 15:19:28.0929 (UTC) FILETIME=[34A84110:01C7C561]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-12 at 10:54 +0200, Pavel Machek wrote:
> > Sorry, I should have re-checked the mail before sending out.
> 
> Were your patches enough to get hibernation working? I got kexec to
> work here, so I guess I'm one step closer...

Yes, it is just the first step. There are still many steps should be
done to get hibernation work.

> ...video does not work in the kexec-ed kernel, unless I boot with
> vga=1.
> 

I will check it.

Best Regards,
Huang Ying
