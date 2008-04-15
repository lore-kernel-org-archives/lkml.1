Return-Path: <linux-kernel-owner+w=401wt.eu-S1764707AbYDONQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764707AbYDONQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 09:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757061AbYDONQL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 09:16:11 -0400
Received: from stinky.trash.net ([213.144.137.162]:36832 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbYDONQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 09:16:09 -0400
Message-ID: <4804AA96.3080609@trash.net>
Date: Tue, 15 Apr 2008 15:16:06 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080109)
MIME-Version: 1.0
To: Andy Gospodarek <andy@greyhouse.net>
CC: Pavel Emelyanov <xemul@openvz.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: 2.6.25-rc9: Reported regressions from 2.6.24
References: <RR4Oy_oXY2J.A.b0H.A3lAIB@albercik> <480262E9.4030500@trash.net> <480267C0.6020402@trash.net> <48026AAE.8040500@trash.net> <20080414203111.GB26591@gospo.usersys.redhat.com> <20080415131413.GC26591@gospo.usersys.redhat.com>
In-Reply-To: <20080415131413.GC26591@gospo.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Gospodarek wrote:
> On Mon, Apr 14, 2008 at 04:31:11PM -0400, Andy Gospodarek wrote:
>> On Sun, Apr 13, 2008 at 10:18:54PM +0200, Patrick McHardy wrote:
>>>
>>> For now I suggest this fix. Andy, could you please test whether it
>>> fixes the problem?
>>>
>>>
>> I'm guessing it will.  I've been testing my older kernels today and
>> somehow I'm unable to reproduce the original problem, so I need to
>> figure out what is different about my config now and before.
>>
>> I'll definitely post back when I test this, but I wanted to make sure
>> you guys knew I was at least trying it. :)
>>
> 
> I just got done testing 159d83363b629c91d020734207c1bc788b96af5a and I
> can confirm that is resolves my issue.


Thanks Andy.


