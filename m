Return-Path: <linux-kernel-owner+w=401wt.eu-S1754015AbZDOP4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015AbZDOP4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:56:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZDOPz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:55:59 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:41418 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751938AbZDOPz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:55:58 -0400
Message-ID: <49E603A9.2010004@oracle.com>
Date: Wed, 15 Apr 2009 08:56:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Takashi Iwai <tiwai@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Subject: Re: [alsa-devel] [PATCH] add missing definitions(letters) to 	HD-Audio.txt
References: <dd18b0c30904141431x231a3251v438e365d512f9f95@mail.gmail.com>	 <s5hiql618mt.wl%tiwai@suse.de> <dd18b0c30904150835l6d246bbes648ad50e20690e7e@mail.gmail.com>
In-Reply-To: <dd18b0c30904150835l6d246bbes648ad50e20690e7e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010205.49E60385.0032:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> On Wed, Apr 15, 2009 at 4:03 AM, Takashi Iwai <tiwai@suse.de> wrote:
>> At Tue, 14 Apr 2009 14:31:21 -0700,
>> Justin Mattock wrote:
>>> impact: Add missing definitions(letters).
>>>
>>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>> Thanks, applied now.
>>
>> (BTW, your patch couldn't be applied cleanly, partly because of
>>  a wrong format and partly because of your MUA breaking the lines...)
>>
>>
>> Takashi
>>
>>> ---
>>>  Documentation/sound/alsa/HD-Audio.txt | 3 +++
>>>  1 files changed,3 insertions(+),0 deletions(-)
>>>
>>> ===========================================================================================
>>> ---- Documentation/sound/alsa/HD-Audio.txt        2009-04-14
>>> 17:03:14.000000000 -0700
>>> ++++ Documentation/sound/alsa/HD-Audio.txt        2009-04-14
>>> 21:15:22.000000000 -0700
>>> @@ -162,7 +162,7 @@
>>>  What `model` option values are available depends on the codec chip.
>>>  Check your codec chip from the codec proc file (see "Codec Proc-File"
>>>  section below).  It will show the vendor/product name of your codec
>>> -chip.  Then, see Documentation/sound/alsa/HD-Audio-Modelstxt file,
>>> +chip.  Then, see Documentation/sound/alsa/HD-Audio-Models.txt file,
>>>  the section of HD-audio driver.  You can find a list of codecs
>>>  and `model` options belonging to each codec.  For example, for Realtek
>>>  ALC262 codec chip, pass `model=ultra` for devices that are compatible
>>> @@ -170,7 +170,7 @@
>>>
>>>  Thus, the first thing you can do for any brand-new, unsupported and
>>>  non-working HD-audio hardware is to check HD-audio codec and several
>>> -different `model` option values.  If you have a luck, some of them
>>> +different `model` option values.  If you have any luck, some of them
>>>  might suit with your device well.
>>>
>>>  Some codecs such as ALC880 have a special model option `model=test`.
>>>
>>> --
> 
> I went diff -u file.old file.new
> (I'm not sure how to generate the
> 1 files changed,2 etc... stuff)

It's listed in Documentation/SubmittingPatches:  /diffstat/
along with the expected patch format etc.
Please read/use it.

> And yes I will be honest I didn't test the patch.
> (figured it wasn't that complicated, and I was tired).
> 
> If I find more I'll let you know.
> (back to trying to get sound working on my imac).


-- 
~Randy
