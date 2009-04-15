Return-Path: <linux-kernel-owner+w=401wt.eu-S1754763AbZDOPfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbZDOPfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 11:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZDOPfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 11:35:21 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:48342 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZDOPfU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 11:35:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=f7Ej7IkZeEoKOIhQ6zECXd5uweR5ZfF8YyjHQEvekMOFhQ2PgyakqjPUkFQqiTPK6r
         8ursqTz+JGCtD3Ob9oMSnjWaguHzIy3X8R/lTyPskBXw4zjPqbWehmkGCm9yyW2ktoFd
         JY83xq7GoJ8DbN4r98a7hhjQ+DSXIOUoNTth4=
MIME-Version: 1.0
In-Reply-To: <s5hiql618mt.wl%tiwai@suse.de>
References: <dd18b0c30904141431x231a3251v438e365d512f9f95@mail.gmail.com>
	 <s5hiql618mt.wl%tiwai@suse.de>
Date: Wed, 15 Apr 2009 08:35:18 -0700
Message-ID: <dd18b0c30904150835l6d246bbes648ad50e20690e7e@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] add missing definitions(letters) to 
	HD-Audio.txt
From: Justin Mattock <justinmattock@gmail.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 4:03 AM, Takashi Iwai <tiwai@suse.de> wrote:
> At Tue, 14 Apr 2009 14:31:21 -0700,
> Justin Mattock wrote:
>>
>> impact: Add missing definitions(letters).
>>
>> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>
>
> Thanks, applied now.
>
> (BTW, your patch couldn't be applied cleanly, partly because of
>  a wrong format and partly because of your MUA breaking the lines...)
>
>
> Takashi
>
>>
>> ---
>>  Documentation/sound/alsa/HD-Audio.txt | 3 +++
>>  1 files changed,3 insertions(+),0 deletions(-)
>>
>> ===========================================================================================
>> ---- Documentation/sound/alsa/HD-Audio.txt        2009-04-14
>> 17:03:14.000000000 -0700
>> ++++ Documentation/sound/alsa/HD-Audio.txt        2009-04-14
>> 21:15:22.000000000 -0700
>> @@ -162,7 +162,7 @@
>>  What `model` option values are available depends on the codec chip.
>>  Check your codec chip from the codec proc file (see "Codec Proc-File"
>>  section below).  It will show the vendor/product name of your codec
>> -chip.  Then, see Documentation/sound/alsa/HD-Audio-Modelstxt file,
>> +chip.  Then, see Documentation/sound/alsa/HD-Audio-Models.txt file,
>>  the section of HD-audio driver.  You can find a list of codecs
>>  and `model` options belonging to each codec.  For example, for Realtek
>>  ALC262 codec chip, pass `model=ultra` for devices that are compatible
>> @@ -170,7 +170,7 @@
>>
>>  Thus, the first thing you can do for any brand-new, unsupported and
>>  non-working HD-audio hardware is to check HD-audio codec and several
>> -different `model` option values.  If you have a luck, some of them
>> +different `model` option values.  If you have any luck, some of them
>>  might suit with your device well.
>>
>>  Some codecs such as ALC880 have a special model option `model=test`.
>>
>>
>>
>> --
>> Justin P. Mattock
>> _______________________________________________
>> Alsa-devel mailing list
>> Alsa-devel@alsa-project.org
>> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
>>
>

I went diff -u file.old file.new
(I'm not sure how to generate the
1 files changed,2 etc... stuff)
And yes I will be honest I didn't test the patch.
(figured it wasn't that complicated, and I was tired).

If I find more I'll let you know.
(back to trying to get sound working on my imac).

-- 
Justin P. Mattock
