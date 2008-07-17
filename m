Return-Path: <linux-kernel-owner+w=401wt.eu-S1755205AbYGQF47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755205AbYGQF47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 01:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbYGQF4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 01:56:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:62507 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYGQF4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 01:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=dte/hgYz5JFigv0Wzi1S4CDEiMgsXOw/PBxL7KhCmungZSKQttMvzkzqRk4loKO+VQ
         3IY5oC14rm/RZNSvq+5zSFaCXQpGtfg2T8JJ1tkYTQmrgN/jf5IUrfzC9ZjppF2LxbL5
         3PHMc5OiZ/AICoG1pTF+2m+9r7y7RG6zUqGVE=
Message-ID: <487EECDF.1040401@gmail.com>
Date: Thu, 17 Jul 2008 06:55:27 +0000
From: Richard <tuxbox.guru@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080614)
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "andreas.herrmann3" <andreas.herrmann3@amd.com>, eumaster@gmail.com,
       uli.geins@geins-web.de
Subject: Re: [PATCH] Re: AMD Mobile Semprons (3500+, 3600+,...) break with
 nohz and highres enabled
References: <1213638474.1684.21.camel@queen.suse.de> <200807161827.16898.trenn@suse.de> <alpine.LFD.1.10.0807162100380.4316@apollo.tec.linutronix.de> <200807162156.00983.trenn@suse.de>
In-Reply-To: <200807162156.00983.trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Renninger wrote:
> I have no idea.
> Richard's last message:
> "I can help out as needed, just a work deadline I have to meet so I 
> haven't been able to dig further.  Just point me in the direction and 
> I'll gladly be someones hands on the beastly machine"
>
> has silently be ignored.
>
>   
>> Which chipset is 
>> involved here ? SB400/600 perhaps ?
>>     
> No, it is probably much older and I am pretty sure that it is not chipset 
> related, but related to the "Mobile" in the Mobile Sempron as this exactly 
> seem to hit 3500 and 3600 Mobile Sempron CPUs.
>
> I can't help much further because:
>   - I have not such a machine
>   - I don't know these parts. I hoped to get some hints to help these guys
>
>        Thomas
>
>   
Hi All,

I am still available to hack away :-) I would also like to get this bug 
resolved but I feel I am out of my depth with this problem. (Embedded 
PowerPC's are my toys)

As a quick test, I grabbed the 2.6.26 kernel and built it... but alas, 
it broke... well, from my ill-educated guess, it looked like acpid done 
something and the machine shut down.

Richard

