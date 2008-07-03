Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYGCMK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYGCMK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752264AbYGCMKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:10:14 -0400
Received: from mga11.intel.com ([192.55.52.93]:12148 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbYGCMKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:10:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,742,1204531200"; 
   d="scan'208";a="584662178"
Subject: Re: [RFC PATCH 4/4] x86_32: mark ACPI NVS memory region
From: Zhang Rui <rui.zhang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
In-Reply-To: <20080703082720.GA4389@elte.hu>
References: <1215051879.5628.36.camel@rzhang-dt.sh.intel.com>
	 <20080703082720.GA4389@elte.hu>
Content-Type: text/plain
Date: Thu, 03 Jul 2008 16:44:14 +0800
Message-Id: <1215074654.3214.11.camel@rzhang-dt.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-07-03 at 16:27 +0800, Ingo Molnar wrote:
> 
> * Zhang Rui <rui.zhang@intel.com> wrote:
> 
> >
> > x86_32: Mark ACPI NVS memory region.
> >
> > Signed-off-by: Zhang Rui <rui.zhang@intel.com>
> > ---
> >  arch/x86/kernel/e820_32.c |   26 ++++++++++++++++++++++++++
> 
> please do this change against tip/master or linux-next, as this file
> has
> been heavily modified and unified already. See:
> 
>  http://people.redhat.com/mingo/tip.git/README
> 
>   
Okay, will re-base this patch set on top of linux-next later.

thanks,
rui

