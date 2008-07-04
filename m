Return-Path: <linux-kernel-owner+w=401wt.eu-S1758961AbYGDPjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961AbYGDPjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 11:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752977AbYGDPjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 11:39:16 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:28142 "EHLO
	VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYGDPjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 11:39:15 -0400
X-BigFish: VPS-11(zz154dM98dR62a3L7efVzz10d3izzz32i6bh87il62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 7,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K3HNH0-01-1Y5-01
Date: Fri, 4 Jul 2008 17:39:04 +0200
From: Robert Richter <robert.richter@amd.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH 0/11] x86/pci 32/64 bit merge
Message-ID: <20080704153904.GB24285@erda.amd.com>
References: <1215031829-29124-1-git-send-email-robert.richter@amd.com> <200807031219.01615.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <200807031219.01615.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 Jul 2008 15:39:05.0150 (UTC) FILETIME=[173615E0:01C8DDEC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse,

On 03.07.08 12:19:01, Jesse Barnes wrote:
> In general it looks pretty nice and smaller than I would have guessed.  I'd 
> like to see each change have a nicer changelog though, explaining things more 
> than the one line patch summary (why, how, etc.).  And like Yinghai mentioned 
> there may be other changes in the x86 tree that you have to deal with in 
> order to merge this; I can pull those into my PCI linux-next tree though to 
> make things easier.

I will look for changes in other x86 feature trees and cherry-pick all
of them for tip/pci-for-jesse. This will resolve existing conflicts as
well. If the conflicts have small impact, I will create follow on
patches. So, I am fine with applying this patch series to
pci/linux-next.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

