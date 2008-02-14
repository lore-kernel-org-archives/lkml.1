Return-Path: <linux-kernel-owner+w=401wt.eu-S1761603AbYBNSZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761603AbYBNSZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 13:25:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758534AbYBNSZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 13:25:25 -0500
Received: from mga06.intel.com ([134.134.136.21]:22164 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758125AbYBNSZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 13:25:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,353,1199692800"; 
   d="scan'208";a="339988793"
Message-ID: <47B4876B.6020100@linux.intel.com>
Date: Thu, 14 Feb 2008 10:24:43 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Stephen Hemminger <shemminger@linux-foundation.org>,
       Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jiri Slaby <jirislaby@gmail.com>,
       Pavel Machek <pavel@suse.cz>, Christoph Hellwig <hch@lst.de>,
       Dominik Brodowski <linux@brodo.de>, Andi Kleen <ak@suse.de>,
       Adrian Bunk <bunk@stusta.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Nick Piggin <npiggin@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Len Brown <len.brown@intel.com>
Subject: Re: Feature Removals for 2.6.25
References: <1201829922.23523.68.camel@brick>	<47B3AC24.5050605@tmr.com> <20080213185502.0005dd4d@extreme> <47B48564.1010709@tmr.com>
In-Reply-To: <47B48564.1010709@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Note that because the hardware is old, it's highly likely that most of 
> it will be retired before that sk98lin driver needs a change. I can't 
> see anyone using sk98lin on a new system, so it would be less 
> contentious to let the hardware (or users) die of natural causes if you 
> can.
> 

the problem is that the new one DOES NOT GET FIXED.
THAT is a huge problem; it means we have a buggy driver...
