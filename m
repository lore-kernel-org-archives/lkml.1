Return-Path: <linux-kernel-owner+w=401wt.eu-S1764626AbXF1L6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764626AbXF1L6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 07:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbXF1L6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 07:58:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:3367 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbXF1L6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 07:58:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=kBVd3prZjFTsBrsT2xZqdazt3P43h37viBokC1i5NldzO84mt8jU9uZwb9h1i9yjq8eNiY3r8u4ub2Fb/Olmcg8PHj/ZRCKk2o0DmDiPrzwxDINVR8NXyHxFyQ7u+CtTi0v08SK0p+2by7KxNYGcH/L2+y8EaXxbBCfHfY6dRZ8=
Message-ID: <4683A26F.7050600@googlemail.com>
Date: Thu, 28 Jun 2007 13:58:39 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070617)
MIME-Version: 1.0
To: =?UTF-8?B?VG9tYXN6IEvFgm9jemtv?= <kloczek@rudy.mif.pg.gda.pl>
CC: Patrick Draper <pdraper@gmail.com>, Rene Herman <rene.herman@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Is it time for remove (crap) ALSA from kernel tree ?
References: <200706271825.17459.ahartmetz@gmail.com> <46829E82.6080804@gmail.com> <200706272110.50744.ahartmetz@gmail.com> <4682EEDD.4020501@gmail.com> <4682FE5C.5070004@gmail.com> <468315AF.1080105@gmail.com> <4683252B.9010205@gmail.com> <Pine.BSO.4.63.0706281336260.25800@rudy.mif.pg.gda.pl>
In-Reply-To: <Pine.BSO.4.63.0706281336260.25800@rudy.mif.pg.gda.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomasz Kłoczko wrote:
> On Wed, 27 Jun 2007, Patrick Draper wrote:
>
>   
>> Rene Herman wrote:
>>     
>>> So -- the fact that mixing actually works for you when using libaoss means 
>>> software mixing is working correctly for your ALSA setup. The only thing 
>>> you should do is _use_ ALSA (natively) and not its OSS emulation so you can 
>>> drop the library preload.
>>>       
>> Cool. How do I go about figuring out what every app uses? For example, you 
>> mentioned that the flash 9 plugin, which I also use, is an ALSA aware 
>> application. How do you know? I need the check out everything that I use 
>> which needs sound (vmware, skype, kmplayer, etc.) I don't have source code 
>> for at least two of those.
>>     
>
> If can I join .. (again)
>   
Heh =)

> ALSA does not privide application mixer settings on application level. 
> Some messages on skype forums suggests some workarouds in ~/.asoudrc 
> but where is documentation for this part ?
>   
You may want to read this one:

http://www.alsa-project.org/alsa-doc/doc-php/asoundrc.php

> Anywhere are described ALSA diagnostics procedures/technics ?
>
> kloczek
>   

Gabriel C
