Return-Path: <linux-kernel-owner+w=401wt.eu-S1760478AbYGPQd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760478AbYGPQd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757964AbYGPQdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:33:49 -0400
Received: from mga06.intel.com ([134.134.136.21]:28449 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757940AbYGPQdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:33:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,374,1212390000"; 
   d="scan'208";a="315845641"
Message-ID: <487E22EA.8030005@linux.intel.com>
Date: Wed, 16 Jul 2008 18:33:46 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: akataria@vmware.com, Ingo Molnar <mingo@elte.hu>,
       "Brown, Len" <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       TJ <linux@tjworld.net>
Subject: Re: acpi based pci gap calculation  - v3
References: <1216148382.6135.21.camel@alok-dev1> <200807151553.41403.jbarnes@virtuousgeek.org> <487D89E3.9070604@linux.intel.com> <200807160906.43632.jbarnes@virtuousgeek.org>
In-Reply-To: <200807160906.43632.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The only problem there is that linux-next doesn't get nearly the sort of 
> testing coverage we need for this kind of change.

Normally I tend to wait for one -mm release, which seems to be tested
by a reasonable number of people. If it survives that it is good
to be tested in Linus' tree.

Just stuffing this in in literally the last minute doesn't seem
like a good idea.

-Andi
