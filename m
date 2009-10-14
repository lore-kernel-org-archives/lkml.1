Return-Path: <linux-kernel-owner+w=401wt.eu-S1761157AbZJNSmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761157AbZJNSmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 14:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758232AbZJNSmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 14:42:39 -0400
Received: from lucidpixels.com ([75.144.35.66]:44110 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755293AbZJNSmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 14:42:38 -0400
Date: Wed, 14 Oct 2009 14:42:02 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31.3: Machine hangs at reboot (Intel DP55KG motherboard)
In-Reply-To: <alpine.DEB.2.00.0910141123280.23631@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.0910141441410.5322@p34.internal.lan>
References: <alpine.DEB.2.00.0910131723510.5034@p34.internal.lan> <alpine.DEB.2.00.0910141123280.23631@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 14 Oct 2009, Justin Piszcz wrote:

>
>
> On Tue, 13 Oct 2009, Justin Piszcz wrote:
>
>> Hello,
>> 
>> When I reboot my system, it hangs:
>> http://home.comcast.net/~jpiszcz/20091013/system-hangs-at-reboot.jpg
>> 
>> It says...
>> 
>> Restarting system.
>> machine restart
>> 
>> Then it sits there and does nothing.
>> 
>> Has anyone seen this before?
>> 
>> BTW-- Thanks for the INTEL network driver info, running 1.0.15-NAPI and its 
>> working nicely, can't wait until its included in the upstream release.
>> 
>> Justin.
>> 
>
> Thoughts? Or work-arounds to this problem?
>
> Machine rebooted fine when I used a different motherboard (same kernel/distro 
> etc).
>
> Justin.
>

Update--

init 0 shuts the machine off (powers down completely) but reboot hangs..

Justin.
