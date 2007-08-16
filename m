Return-Path: <linux-kernel-owner+w=401wt.eu-S1763496AbXHPHuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763496AbXHPHuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 03:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXHPHuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 03:50:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:39452 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbXHPHui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 03:50:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,270,1183359600"; 
   d="scan'208";a="279632611"
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
In-Reply-To: <20070815154245.500c572c.akpm@linux-foundation.org>
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	 <20070815154245.500c572c.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Aug 2007 15:51:04 +0800
Message-Id: <1187250664.15063.0.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 16 Aug 2007 07:50:35.0383 (UTC) FILETIME=[210EC870:01C7DFDA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 06:42 +0800, Andrew Morton wrote:
> On Mon, 13 Aug 2007 15:30:19 +0800
> "Huang, Ying" <ying.huang@intel.com> wrote:
> 
> > Following sets of patches add EFI/UEFI (Unified Extensible Firmware
> > Interface) runtime services support to x86_64 architecture.
> 
> I had to rework these a bit due to clashes with
> x86_64-add-acpi-reboot-option.patch.  Please check carefully that
> everything landed OK.
> 
OK, I will be more careful next time.

Best Regards,
Huang Ying
