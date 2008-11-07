Return-Path: <linux-kernel-owner+w=401wt.eu-S1753144AbYKGO3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbYKGO3W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 09:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYKGO3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 09:29:04 -0500
Received: from one.firstfloor.org ([213.235.205.2]:60858 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYKGO3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 09:29:02 -0500
To: Dave Hudson <linux-kernel@blueteddy.net>
Cc: Ilpo =?utf-8?Q?J=C3=A4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Mikael Abrahamsson <swmike@swm.pp.se>,
       David Miller <davem@davemloft.net>, daniel.blueman@gmail.com,
       LKML <linux-kernel@vger.kernel.org>, Netdev <netdev@vger.kernel.org>,
       linux-net@vger.kernel.org
Subject: Re: time for TCP ECN defaulting to on?
From: Andi Kleen <andi@firstfloor.org>
References: <6278d2220811040632u7a36d68ekad5de517fd0671bb@mail.gmail.com>
	<alpine.DEB.1.10.0811052316210.10993@uplift.swm.pp.se>
	<20081105.151015.206163697.davem@davemloft.net>
	<alpine.DEB.1.10.0811070529550.10993@uplift.swm.pp.se>
	<Pine.LNX.4.64.0811070931190.23284@wrl-59.cs.helsinki.fi>
	<4914240F.7050701@blueteddy.net>
Date: Fri, 07 Nov 2008 15:33:53 +0100
In-Reply-To: <4914240F.7050701@blueteddy.net> (Dave Hudson's message of "Fri, 07 Nov 2008 11:18:39 +0000")
Message-ID: <87k5bfppv2.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hudson <linux-kernel@blueteddy.net> writes:
>
> Not all of the routers in question (the ones that crash, block packets
> or otherwise misbehave) are provided by ISPs - in fact a huge number
> of them are and have been sold retail.  Over time most of those boxes
> will get replaced with ones that don't have the problem because most
> (probably all major) SOHO router suppliers now test that they don't
> break with ECN so eventually there will be a point where enabling ECN
> by default will make a lot of sense (there will be too few broken
> routers to care about).

One option would be also to enable it by default for IPv6 only.

-Andi

-- 
ak@linux.intel.com
