Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608Ab0AKXQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab0AKXQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 18:16:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403Ab0AKXQD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 18:16:03 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:32728 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843Ab0AKXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 18:16:01 -0500
X-Trace: 322810413/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.28.176/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.28.176
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-Originating-Country: GB/UNITED KINGDOM
X-MUA: Alpine 2.00 (LSU 1167 2008-08-23)
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUBAP4/S0tPRRyw/2dsb2JhbAAIgizUP4QvBA
X-IronPort-AV: E=Sophos;i="4.49,258,1262563200"; 
   d="scan'208";a="322810413"
Date: Mon, 11 Jan 2010 23:15:50 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [Bug #15033] drm: gem_object_free without struct_mutex
In-Reply-To: <omZ8aBZReyD.A.zcG.3MlSLB@chimera>
Message-ID: <alpine.LSU.2.00.1001112304480.6409@sister.anvils>
References: <wnS54-l8PVO.A.TlF.oMlSLB@chimera> <omZ8aBZReyD.A.zcG.3MlSLB@chimera>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jan 2010, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15033
> Subject		: drm: gem_object_free without struct_mutex
> Submitter	: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> Date		: 2009-12-30 19:45 (12 days old)
> References	: http://marc.info/?l=linux-kernel&m=126220236201529&w=4
> Handled-By	: Jesse Barnes <jbarnes@virtuousgeek.org>

Thanks, Rafael: please close it now.  I just checked latest -git
and it is now fixed (but not fixed in 2.6.33-rc3) - thanks, Chris.

Hugh
