Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYCMHC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYCMHC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 03:02:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751572AbYCMHCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 03:02:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:31632 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333AbYCMHCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 03:02:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,492,1199692800"; 
   d="scan'208";a="533125005"
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc5
From: "Zhang, Rui" <rui.zhang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrea Arcangeli <andrea@qumranet.com>
In-Reply-To: <20080312234516.bb079cc5.akpm@linux-foundation.org>
References: <200803130214.36861.lenb@kernel.org>
	 <20080312234516.bb079cc5.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 13 Mar 2008 14:51:45 +0800
Message-Id: <1205391105.2240.68.camel@acpi-hp-zz.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-03-12 at 23:45 -0700, Andrew Morton wrote:
> On Thu, 13 Mar 2008 02:14:36 -0400 Len Brown <lenb@kernel.org> wrote:
> 
> > please pull from: 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> > 
> > A bunch of small regression fixes, bug fixes, and a couple of minor cleanups.
> 
> I hope Rafael knows how to cross-reference the regression fixes against his list?
> 
> 
> 
> I'm sitting on five ACPI patches which look like they (or alternatives?) should
> be in 2.6.25:
> 
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/acpi-ec-revert-208c70a45624400fafd7511b96bc426bf01f8f5e.patch
> 
>   This was too poorly changelogged for me to remember what problem it
>   solves, but it seemed important at the time.
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-acpi-asus_acpic-correct-use-of-and.patch
> 
>   Fix logic error in asus_acpi.c
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/drivers-acpi-asus_acpic-correct-use-of-and.patch
> 
>   Fix an overrun.
> 
> http://userweb.kernel.org/~akpm/mmotm/broken-out/revert-acpi-thermal-fixup.patch
> 
>   Hopeully fix a regression which Andrea Arcangeli hit.  Although I'm not sure
>   that he has confirmed that this revert actually works?
Well, the patch looks good, this may be caused by a BIOS problem.
anyway, I wish to get the response from Andrea so that I can do some
investigation ASAP.

thanks,
rui


