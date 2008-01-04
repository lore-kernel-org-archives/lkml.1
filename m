Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbYADBgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbYADBgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 20:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbYADBfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 20:35:54 -0500
Received: from proxy1.bredband.net ([195.54.101.71]:36757 "EHLO
	proxy1.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbYADBfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 20:35:54 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AnpUAMYcfUdT48OPRmdsb2JhbACBV4YPiCEBAQE3gSKYbw
Message-ID: <477D8D73.6020303@coderworld.net>
Date: Fri, 04 Jan 2008 02:35:47 +0100
From: Richard Jonsson <richie@coderworld.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andreas Mohr <andi@lisas.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: forcedeth: MAC-address reversed on resume from suspend
References: <477BFC71.7090002@coderworld.net> <20080102214843.GA19224@rhlx01.hs-esslingen.de>
In-Reply-To: <20080102214843.GA19224@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know, this all looks a bit dirty to me, MAC reading/writing
> should have been implemented in a more central way, then those people
> wouldn't have confused heaven and hell with MAC address fiddling.
> 
> And yeah, this certainly looks like a bug that should be fixed ASAP,
> unless my short analysis somehow happened to be wrong.
> (I could probably fix it, but then the forcedeth people
> most likely know better how they would like to see it implemented)
> 
> Thank you for your report!
> 
Thank you for looking into this, it's a major pain for me. If I knew how 
to, I would have submitted a patch along with the report, if I had the 
know-how. I'd be happy to help in any way I can.

> Now the only thing remaining would be: is there a specific way to
> contact forcedeth-related people? I didn't find anything within a short
> search.
> 
> Andreas Mohr

Well, I did search the maintainers file, and did some googling, but 
didn't find any contact info.

/ Richard
