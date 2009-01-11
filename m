Return-Path: <linux-kernel-owner+w=401wt.eu-S1754759AbZAKAdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759AbZAKAdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 19:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbZAKAd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 19:33:27 -0500
Received: from yw-out-2324.google.com ([74.125.46.30]:28185 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbZAKAd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 19:33:27 -0500
Message-ID: <fa686aa40901101633r71a143cam21e954d5b0d61fdd@mail.gmail.com>
Date: Sat, 10 Jan 2009 17:33:26 -0700
From: "Grant Likely" <grant.likely@secretlab.ca>
To: "Richard Purdie" <rpurdie@rpsys.net>
Subject: Re: [GIT PULL] LED updates for 2.6.29
Cc: "Trent Piepho" <xyzzy@speakeasy.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Guennadi Liakhovetski" <lg@denx.de>
In-Reply-To: <1231543199.5317.63.camel@dax.rpnet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1231500186.5317.9.camel@dax.rpnet.com>
	 <Pine.LNX.4.64.0901091231310.22972@t2.domain.actdsltmp>
	 <1231543199.5317.63.camel@dax.rpnet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 9, 2009 at 4:19 PM, Richard Purdie <rpurdie@rpsys.net> wrote:
> On Fri, 2009-01-09 at 12:37 -0800, Trent Piepho wrote:
>> On Fri, 9 Jan 2009, Richard Purdie wrote:
>> > for the LED tree updates for 2.6.29. This includes some new drivers,
>> > bugfixes and a core improvement resulting in nicer code.
>> >
>>
>> Any chance of these patches getting accepted?  They've been going back and
>> forth for months now.
>>
>> [v2,1/4] leds: Support OpenFirmware led bindings
>> http://patchwork.ozlabs.org/patch/13581/
>>
>> [v2,2/4] leds: Add option to have GPIO LEDs start on
>> http://patchwork.ozlabs.org/patch/13580/
>>
>> [v2,3/4] leds: Let GPIO LEDs keep their current state
>> http://patchwork.ozlabs.org/patch/13583/
>>
>> [v2,4/4] leds: Use tristate property in platform data
>> http://patchwork.ozlabs.org/patch/13584/
>
> I think there was some confusion as to who was going to take them. Are
> the PPC people happy with them? If so I'll merge through the LED tree.
> There are these and a couple of other patches around which have got lost
> in the system. If there is time which I'm hoping there might be, I'll
> try and get a second LED tree merge in.

I'm cool with them going in from the ppc side.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
