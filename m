Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbYHSMiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbYHSMiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 08:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753178AbYHSMiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 08:38:08 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:33486 "EHLO
	WA4EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbYHSMiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 08:38:07 -0400
X-BigFish: VPS-34(z6f5iz1432R98dR936eQ62a3L1805Mzz10d3izz5a6ciz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0K5ULR5-02-099-01
Date: Tue, 19 Aug 2008 14:37:36 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <ak@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pavel Machek <pavel@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Philippe Elie <phil.el@wanadoo.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: oprofile + hibernation = badness
Message-ID: <20080819123736.GE1488@erda.amd.com>
References: <19f34abd0808181332k3c02496auabd04e927bb7cab5@mail.gmail.com> <48AA1E42.6070802@linux.intel.com> <19f34abd0808190012r4418cc4egf9bc25a52056af41@mail.gmail.com> <20080819094905.GA20590@elte.hu> <48AAB8B6.3020802@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48AAB8B6.3020802@linux.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 19 Aug 2008 12:37:56.0600 (UTC) FILETIME=[680D7780:01C901F8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.08.08 14:12:38, Andi Kleen wrote:
> Ingo Molnar wrote:
>> * Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>> This gets rid of the suspend warnings, so it looks to be a step in the 
>>> right direction! FWIW, you may add my Tested-by to the patch.
>> i've queued it up in tip/x86/oprofile - thanks guys.
>
> I would have thought Robert would take them? He's oprofile
> maintainer after all.

Yes, as soon as I have my own repository available this will change.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

