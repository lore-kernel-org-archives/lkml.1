Return-Path: <linux-kernel-owner+w=401wt.eu-S1755906AbZAAU1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906AbZAAU1T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 15:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbZAAU1J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 15:27:09 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39607 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbZAAU1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 15:27:09 -0500
Date: Thu, 1 Jan 2009 21:27:04 +0100
From: Andreas Mohr <andi@lisas.de>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Andreas Mohr <andi@lisas.de>, Bob Copeland <me@bobcopeland.com>,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Bugs on aspire one A150
Message-ID: <20090101202704.GA19959@rhlx01.hs-esslingen.de>
References: <1230641016.5770.5.camel@maxim-laptop> <20081231091845.GA2516@rhlx01.hs-esslingen.de> <20081231140308.GA26600@hash.localnet> <1230742291.26499.22.camel@maxim-laptop> <20090101134100.GA4819@rhlx01.hs-esslingen.de> <1230819317.30244.6.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230819317.30244.6.camel@maxim-laptop>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jan 01, 2009 at 04:15:17PM +0200, Maxim Levitsky wrote:
> Nether does second led works here, even with Win XP that this netbook
> came with.
> I suspect, that this is usual outcome of an acer tradition, I mean
> shipping notebooks with all bluetooch equipment except the actual device
> (I mean my notebook has a BT led, BT button, but not a BT device)
> 
> I suspect that this led is intended for BT.
> 
> Also there is a wireless sign near wireless led, and none near the other
> led, and I guess there should have been a BT sign.

Not BT, unallocated 3G socket!
(at least that's what i strongly suspect)

Then the question would be how this is hooked up - hard-wired to 3G
socket or possibly via a function in the Embedded Controller?? (which one could
then abuse for other things)

And many thanks to Bob for his new iteration of LED / GPIO count patches!

Andreas Mohr
