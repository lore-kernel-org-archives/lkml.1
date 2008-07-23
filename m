Return-Path: <linux-kernel-owner+w=401wt.eu-S1754981AbYGWUBx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981AbYGWUBx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 16:01:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYGWUBo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 16:01:44 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:49747 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbYGWUBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 16:01:43 -0400
X-BigFish: VPS-26(zz1432R98dR936eT62a3L1805M936fT2f55kzz10d3izzz32i6bh87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4H6A8-01-ELM-01
Date: Wed, 23 Jul 2008 22:01:19 +0200
From: Robert Richter <robert.richter@amd.com>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: apic: Changing export symbols to *_GPL
Message-ID: <20080723200119.GI17134@erda.amd.com>
References: <20080722125315.5d34f2e6@infradead.org> <20080723184709.ECF218403@erda.amd.com> <Pine.LNX.4.61.0807231525490.30326@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0807231525490.30326@chaos.analogic.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 23 Jul 2008 20:01:26.0965 (UTC) FILETIME=[E3E9AE50:01C8ECFE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.07.08 15:29:59, linux-os (Dick Johnson) wrote:
> 
> On Wed, 23 Jul 2008, Robert Richter wrote:
> 
> > This fits better here.
> 
> [Snipped...]
> This question was raised before and simply dismissed.
> 
> If somebody wrote a procedure in the kernel that exported
> some symbols. And that person wanted anybody to use that
> symbol, upon what authority does one change "EXPORT_SYMBOL"
> to "EXPORT_SYMBOL_GPL?" This will need to eventually be
> answered.

This corrects a patch _I_ introduced before in my OProfile patch
series. Ok, maybe a revert would have been better. But sending 2 new
patches for this littls change?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

