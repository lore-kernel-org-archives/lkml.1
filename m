Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYGVVB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYGVVB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbYGVVAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:00:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:43774 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755151AbYGVVAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:00:50 -0400
Message-ID: <48864A7F.3050908@sgi.com>
Date: Tue, 22 Jul 2008 14:00:47 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, suresh.b.siddha@intel.com, hpa@zytor.com,
       tglx@linutronix.de, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/26] x64, x2apic/intr-remap: Interrupt-remapping and
 x2apic support
References: <20080710181634.764954000@linux-os.sc.intel.com>	<20080710195320.GA23322@elte.hu> <20080722134909.2cbf719b.akpm@linux-foundation.org>
In-Reply-To: <20080722134909.2cbf719b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 10 Jul 2008 21:53:20 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
>> For review and testing purposes i've created a new topic branch for 
>> this: tip/x86/x2apic and have picked up your patches into it.
> 
> This has today turned up in linux-next and I'm having to rework 2.6.27
> patches to compensate for it.
> 
> Which means that I now need to wait until this work goes into mainline
> before I can merge those patches or I need to undo those fixes, route
> around Suresh's changes and then force you to fix the resulting damage.
> 
> What's the score here?  Is this stuff going into 2.6.27?

Hi Andrew,

Jack is out at OLS this week, but yes I believe we're trying to push this
into 6.2.27 as that is what the distro's will be basing their distributions
on when the new system sees the light of day.

Is there something I can do to help?  Perhaps work on conflict resolutions?

Thanks,
Mike
