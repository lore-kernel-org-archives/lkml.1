Return-Path: <linux-kernel-owner+w=401wt.eu-S1763383AbXGFQh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763383AbXGFQh3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 12:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754124AbXGFQhQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 12:37:16 -0400
Received: from mga07.intel.com ([143.182.124.22]:49773 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758818AbXGFQhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 12:37:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,509,1175497200"; 
   d="scan'208";a="247303138"
Message-ID: <468E6F4C.8000601@linux.intel.com>
Date: Fri, 06 Jul 2007 09:35:24 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5 (Windows/20051201)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Liunx power consumption on laptops -- Enormous progress in the
 last few months
References: <468D4D82.8030009@linux.intel.com> <468E6F0C.1090601@redhat.com>
In-Reply-To: <468E6F0C.1090601@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 07/05/2007 03:58 PM, Arjan van de Ven wrote:
>> While it's hard to show "one size fits all" number/percentage, we took a
>> bog standard Lenovo T61 laptop (no vendor preference, they just were the
>> first one to deliver a model with the latest Intel chipset to our cubes)
>> and measured the effect. The baseline we used was a 32 bit Fedora 7
>> installation; note that this already has the tickless kernel, but is
>> lacking several of the key bugfixes that came afterwards.
>>
>> We've put our measurements in a graph at
>>
>> http://ww.linuxpowertop.org/results.php
>>
>> With kernel fixes and features, the power consumption of this laptop
>> went from 21.06 Watts to 18.25 Watts; with 2 additional userspace fixes
>> the power consumption ended up at 15.5 Watts.
>>
> 
> Where is the ondemand-fix.patch? I can't find any link to it.

just click on it in the graph ;_

it's also http://www.linuxpowertop.org/patches/ondemand-fix.patch 
(which is submitted already to the maintainers)
