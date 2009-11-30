Return-Path: <linux-kernel-owner+w=401wt.eu-S1753588AbZK3Gw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbZK3Gw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 01:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZK3Gw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 01:52:57 -0500
Received: from mail-ew0-f215.google.com ([209.85.219.215]:34731 "EHLO
	mail-ew0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZK3Gw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 01:52:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=eQqftTqtvNG4kPCRTu8/iRsWLv0MeDH1LUXZvP9eYchYDiRWD2c0HtTGg32O9ozF5K
         UwhMimeg3ARUgB9VKWiDX1ZGzysWPQvj2Ido8ZaCneQHJZX040K9j+tTVkN5H4ktHwzK
         vx1K5LkNAtGww0XlN9YECjCqjMSfWdkY1Y97U=
Message-ID: <4B136BCA.1030003@gmail.com>
Date: Mon, 30 Nov 2009 11:52:58 +0500
From: "Andrey A. Porodko" <andrey.porodko@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: "Andrey A. Porodko" <Andrey.Porodko@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jorge Luis Zapata Muga <jorgeluis.zapata@gmail.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, Chaithrika U S <chaithrika@ti.com>,
       Troy Kisky <troy.kisky@boundarydevices.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kevin Hilman <khilman@deeprootsystems.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org
Subject: Re: Sound support for Neuros OSD2 Davinci based board.
References: <4B0E7D5E.3080906@chelcom.ru> <20091127164733.GC11913@rakim.wolfsonmicro.main> <4B136A98.4010400@gmail.com>
In-Reply-To: <4B136A98.4010400@gmail.com>
X-Enigmail-Version: 0.96.0
OpenPGP: id=9E6A5CCE
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey A. Porodko wrote:

Please, disregard my previous message. It's me stupid enough to forget
to switch to the right branch.
Sorry.


> Mark Brown wrote:
>   
>> On Thu, Nov 26, 2009 at 06:06:38PM +0500, A. Porodko wrote:
>>   
>>     
>>> Hello,
>>>
>>> Here is a patch for Neuros OSD2 Davinci (DM6446) based board sound support.
>>> Patch made against 2.6.32-rc6 kernel.
>>>     
>>>       
>> This doesn't apply against current ASoC.  Could you please regenerate
>> against this branch:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git for-2.6.33
>>
>>   
>>     
> Hi Mark,
>
> Are you sure you have the latest davinci soc support in your tree?
> Mine file davinci_evm.c is 7.5k size, in your
>
> git://git.kernel.org/pub/scm/linux/kernel/git/broonie/sound-2.6.git
>
> repo your is 5.5k. Quick glance shows that in your repo davinci support
> lacks of da830_evm support.
> I'm confused which one is I have to use and apply patch to?
>
>   


-- 
Best regards
Andrey A. Porodko
 

