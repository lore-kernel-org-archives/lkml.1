Return-Path: <linux-kernel-owner+w=401wt.eu-S933084AbXA2CAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933084AbXA2CAs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 21:00:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933089AbXA2CAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 21:00:48 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:42035 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933084AbXA2CAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 21:00:48 -0500
Message-ID: <45BD5543.5020704@student.ltu.se>
Date: Mon, 29 Jan 2007 03:00:35 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Oleg Verych <olecom@flower.upol.cz>
CC: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [SCRIPT] Remove "space damage" from patches
References: <45BD177D.6060907@student.ltu.se> <slrnerqapg.f71.olecom@flower.upol.cz> <45BD3AF7.4070902@student.ltu.se> <slrnerqgj0.f71.olecom@flower.upol.cz> <45BD4D2C.2010306@student.ltu.se> <20070129014327.GA25271@flower.upol.cz>
In-Reply-To: <20070129014327.GA25271@flower.upol.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Verych wrote:
> On Mon, Jan 29, 2007 at 02:26:04AM +0100, Richard Knutsson wrote:
> []
>   
>> I also guess you saw that the script is _not_ for cleaning up 
>> source-files (can be intrusive and is better to be fixed when fixing 
>> something else), but patches.
>>     
>
> IMHO it's dealing with consequences, not cause, and it's even worse.
>   
How many patches is not to fix bugs, it is worse then some strayed 
whitespace but it is due to reality.
The best is, of course, if neither happened but the next best thing is 
to fix it. And if it can be automated, even better (imho).
>> So if a maintainer does not have anything to easily fix those, they
>> might want a simple script to do the work (otherwise I believe they
>> just deleted my mail ;) ).
>>     
>
> I would like to discuss, would you?
>   
I like to discuss but I am not sure what the result would be. Force 
people to use the editors of our choice?
As long people uses valid e-mail-clients when sending patches (or they 
use the script "sendpatchset"), I'm think we have to be satisfied.
But if you have any ideas, I'm listening.

Richard Knutsson

