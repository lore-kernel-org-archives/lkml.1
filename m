Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbYKRI6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbYKRI6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 03:58:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbYKRI62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 03:58:28 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:42558 "EHLO
	SG2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYKRI61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 03:58:27 -0500
X-BigFish: VPS-44(zz1432R62a3L98dR936eQ1805M936fOzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KAIU8X-02-59F-01
Date: Tue, 18 Nov 2008 09:57:37 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Eric Dumazet <dada1@cosmosbay.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] oprofile: re-arm APIC_DM_NMI in ppro_check_ctrs()
Message-ID: <20081118085737.GM1664@erda.amd.com>
References: <20081107171339.GQ9785@erda.amd.com> <4917EB51.9020304@cosmosbay.com> <87ljvsott2.fsf@basil.nowhere.org> <491843C4.9090306@cosmosbay.com> <20081110154948.GW29626@one.firstfloor.org> <4919430C.6050502@cosmosbay.com> <20081117173359.GI1664@erda.amd.com> <20081117182527.GO6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081117182527.GO6703@one.firstfloor.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 18 Nov 2008 08:58:07.0214 (UTC) FILETIME=[C62820E0:01C9495B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17.11.08 19:25:27, Andi Kleen wrote:
> On Mon, Nov 17, 2008 at 06:33:59PM +0100, Robert Richter wrote:
> > Is this the patch you all prefer? If so, I would like to send it
> > upstream.
> 
> It would be better to root cause the problem first.
> 
> I worked with Eric privately and tried a few things, but didn't help
> so far. Most likely the workaround is also not complete before
> it is fully understood. Not sure how long this will take though.
> 
> It's probably ok as a workaround for a release, but shouldn't 
> be considered a final fix.

Ok, I will take no action. Let me know if there is a new solution
available or if this workaround should go in.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

