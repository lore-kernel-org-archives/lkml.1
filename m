Return-Path: <linux-kernel-owner+w=401wt.eu-S1763492AbXGFQeh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763492AbXGFQeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 12:34:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbXGFQe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 12:34:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36550 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753891AbXGFQe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 12:34:27 -0400
Message-ID: <468E6F0C.1090601@redhat.com>
Date: Fri, 06 Jul 2007 12:34:20 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Liunx power consumption on laptops -- Enormous progress in the
 last few months
References: <468D4D82.8030009@linux.intel.com>
In-Reply-To: <468D4D82.8030009@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2007 03:58 PM, Arjan van de Ven wrote:
> While it's hard to show "one size fits all" number/percentage, we took a
> bog standard Lenovo T61 laptop (no vendor preference, they just were the
> first one to deliver a model with the latest Intel chipset to our cubes)
> and measured the effect. The baseline we used was a 32 bit Fedora 7
> installation; note that this already has the tickless kernel, but is
> lacking several of the key bugfixes that came afterwards.
> 
> We've put our measurements in a graph at
> 
> http://ww.linuxpowertop.org/results.php
> 
> With kernel fixes and features, the power consumption of this laptop
> went from 21.06 Watts to 18.25 Watts; with 2 additional userspace fixes
> the power consumption ended up at 15.5 Watts.
> 

Where is the ondemand-fix.patch? I can't find any link to it.

