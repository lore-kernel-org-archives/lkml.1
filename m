Return-Path: <linux-kernel-owner+w=401wt.eu-S1765721AbXG0Br0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765721AbXG0Br0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbXG0BrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:47:17 -0400
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:40271 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbXG0BrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:47:16 -0400
Date: Thu, 26 Jul 2007 18:52:00 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: Re: Regression in serial console on ia64 after 2.6.22
In-reply-to: <20070726184130.404a13d3.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Horms <horms@verge.net.au>, linux-ia64 <linux-ia64@vger.kernel.org>,
       Tony Luck <tony.luck@intel.com>, Andi Kleen <ak@suse.de>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Russell King <rmk@arm.linux.org.uk>, Gerd Hoffmann <kraxel@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Reply-to: Yinghai.Lu@Sun.COM
Message-id: <46A94FC0.1050709@sun.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <20070719074147.GA23879@verge.net.au> <46A0191E.3000100@sun.com>
 <200707241657.33095.yinghai.lu@sun.com> <20070725071718.GB18068@verge.net.au>
 <46A76E95.90903@sun.com> <20070726184130.404a13d3.akpm@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 25 Jul 2007 08:39:01 -0700 Yinghai Lu <Yinghai.Lu@Sun.COM> wrote:
> 
>>>> Subject         : Regression in serial console on ia64 after 2.6.22
>>>> References      : http://marc.info/?l=linux-ia64&m=118483645914066&w=2
>>>> Last known good : ?
>>>> Submitter       : Horms <horms@verge.net.au>
>>>> Caused-By       : Yinghai Lu <Yinghai.Lu@Sun.COM>
>>>>                   commit 18a8bd949d6adb311ea816125ff65050df1f3f6e
> 
> afaik we still haven't fixed this and I don't think we've seen
> the final agreed-upon patch?
> 
> Thanks.

Horms' patch already got into mainline via IA64 maintainer...

Thanks

Yinghai Lu
