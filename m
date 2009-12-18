Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbZLRCVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbZLRCVS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 21:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZLRCVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 21:21:16 -0500
Received: from mga11.intel.com ([192.55.52.93]:33283 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912AbZLRCVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 21:21:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,416,1257148800"; 
   d="scan'208";a="524253187"
Date: Fri, 18 Dec 2009 10:21:12 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "Barnes, Jesse" <jesse.barnes@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [git pull request] ACPI and driver patches for 2.6.33.merge
Message-ID: <20091218022112.GA30333@sli10-desk.sh.intel.com>
References: <alpine.LFD.2.00.0912161453480.10371@localhost.localdomain>
 <86802c440912171728s27dd7108k85a0f1563660c95b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86802c440912171728s27dd7108k85a0f1563660c95b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 09:28:50AM +0800, Yinghai Lu wrote:
> On Wed, Dec 16, 2009 at 12:06 PM, Len Brown <lenb@kernel.org> wrote:
> > Hi Linus,
> >
> > please pull from:
> >
> > git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
> >
> ;..
> >
> > Shaohua Li (3):
> >      ACPI: Add a generic API for _OSC -v2
> >      ACPI: cleanup pci_root _OSC code.
> >      ACPI: Add platform-wide _OSC support.
> 
> it seems these three patches broke the _OSC on my intel new systems.
> 
> revert them fix the problem with AER and pciehp and etc
can you give more details? I just cleaned up the _OSC code for AER and pciehp,
no function changes.

Thanks,
Shaohua
