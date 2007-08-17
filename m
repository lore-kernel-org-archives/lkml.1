Return-Path: <linux-kernel-owner+w=401wt.eu-S1762230AbXHQBZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762230AbXHQBZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 21:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbXHQBZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 21:25:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:59192 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbXHQBY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 21:24:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,273,1183359600"; 
   d="scan'208";a="264308821"
Subject: Re: [PATCH 0/3] x86_64 EFI runtime service support
From: "Huang, Ying" <ying.huang@intel.com>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Chandramouli Narayanan <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org, Aaron Durbin <adurbin@google.com>
In-Reply-To: <46C45B22.5090701@suse.de>
References: <1186990219.22431.37.camel@caritas-dev.intel.com>
	 <20070815154245.500c572c.akpm@linux-foundation.org>
	 <1187250664.15063.0.camel@caritas-dev.intel.com> <46C45B22.5090701@suse.de>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Aug 2007 09:25:20 +0800
Message-Id: <1187313920.28497.1.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 17 Aug 2007 01:24:50.0169 (UTC) FILETIME=[67D92690:01C7E06D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-16 at 16:11 +0200, Andi Kleen wrote:
> Huang, Ying wrote:
> > On Thu, 2007-08-16 at 06:42 +0800, Andrew Morton wrote:
> >> On Mon, 13 Aug 2007 15:30:19 +0800
> >> "Huang, Ying" <ying.huang@intel.com> wrote:
> >>
> >>> Following sets of patches add EFI/UEFI (Unified Extensible Firmware
> >>> Interface) runtime services support to x86_64 architecture.
> >> I had to rework these a bit due to clashes with
> >> x86_64-add-acpi-reboot-option.patch.  Please check carefully that
> >> everything landed OK.
> >>
> > OK, I will be more careful next time.
> 
> 
> Has the zero page documentation and version numbering project
> made any progress? I think we cannot merge this without at least
> the version number

OK, I will work on the zero page documentation and version numbering
project.

Best Regards,
Huang Ying
