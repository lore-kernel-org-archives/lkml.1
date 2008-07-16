Return-Path: <linux-kernel-owner+w=401wt.eu-S1756929AbYGPFmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbYGPFmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 01:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751796AbYGPFmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 01:42:09 -0400
Received: from mga07.intel.com ([143.182.124.22]:61643 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751465AbYGPFmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 01:42:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,371,1212390000"; 
   d="scan'208";a="20980730"
Message-ID: <487D8A30.2070702@linux.intel.com>
Date: Wed, 16 Jul 2008 07:42:08 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: akataria@vmware.com
CC: Ingo Molnar <mingo@elte.hu>, "Brown, Len" <len.brown@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-acpi <linux-acpi@vger.kernel.org>
Subject: Re: acpi based pci gap calculation  - v3
References: <1216148382.6135.21.camel@alok-dev1>
In-Reply-To: <1216148382.6135.21.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> Hi Andi,
> 
> I don't see this patch being applied in any of the tree yet.
> Resending this incase you guys might have missed it. 

Sorry still some backlog from vacation last week. However the focus
right now is on patches for 2.6.27 and I don't think your patch
is really tested well enough yet for that. It is fairly intrusive
and changes a critical piece of code. More likely it's a .28 thing,
or possibly a late merge candidate (but that's also not clear)

-Andi
