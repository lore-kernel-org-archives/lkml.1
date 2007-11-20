Return-Path: <linux-kernel-owner+w=401wt.eu-S1755815AbXKTAyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbXKTAyy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 19:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752470AbXKTAyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 19:54:47 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbXKTAyq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 19:54:46 -0500
Date: Mon, 19 Nov 2007 19:54:43 -0500
From: Dave Jones <davej@redhat.com>
To: Stephen Clark <Stephen.Clark@seclark.us>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Power Saving
Message-ID: <20071120005443.GB9243@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Stephen Clark <Stephen.Clark@seclark.us>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <47422D3B.8080704@seclark.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47422D3B.8080704@seclark.us>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2007 at 07:41:31PM -0500, Stephen Clark wrote:
 > Hello List,
 > 
 > I am trying to get throttling to work on the following processor

I think by throttling, you actually mean changing frequency/voltage ?
(throttling is something else, where the CPU skips every n cycles,
 which doesn't actually save any power)

 > with linux 2.6.17-1.2142_FC4 with no luck.

wow. that's a prehistoric kernel.

 > AMD Athlon(tm) XP 1700+

you lose.  Only the mobile athlons supported scaling their speed.
And even then, only if the BIOS supported it with the correct tables.
(Typically this means, "only laptops").

	Dave

-- 
http://www.codemonkey.org.uk
