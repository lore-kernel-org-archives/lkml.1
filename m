Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbZHCCIn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbZHCCIn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 22:08:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752500AbZHCCIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 22:08:42 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:56777 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741AbZHCCIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 22:08:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iFAbdj0qQT1yZNOmZ6Xp+m7iuYwCO7LLkCHP7D4XftIsFNnFfCQEYBTuQkqHPttaL6
         87yHsaEP/gi1psitS/bBY0eVdoMqYw9MdNl5nhr2XsX7+TUvUBTl/nDQX/Nm9BEo2AQs
         tm5Tn+8+onh6jAJbvXLFq9VlPymzkQclG8OzU=
MIME-Version: 1.0
In-Reply-To: <20090802095523.e08166e3.rdunlap@xenotime.net>
References: <a8e1da0908020056mbf28eaw611c605693eb3eff@mail.gmail.com>
	 <20090802095523.e08166e3.rdunlap@xenotime.net>
Date: Mon, 3 Aug 2009 10:08:40 +0800
Message-ID: <a8e1da0908021908x8216693k7fb31bc5b58d6666@mail.gmail.com>
Subject: Re: mm/-next release on kernel.org web page?
From: Dave Young <hidave.darkstar@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: webmaster@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 3, 2009 at 12:55 AM, Randy Dunlap<rdunlap@xenotime.net> wrote:
> On Sun, 2 Aug 2009 15:56:20 +0800 Dave Young wrote:
>
>> Hi,
>>
>> The last mm patchset is 2.6.28-rc2-mm1. We can not download -mm
>> patchset from kernel.org web page since the -next tree born.
>>
>> Could you consider put mmtom release there just like before? And even
>> -next tree patchset? It will be more convenient for users who test
>> kernel just by downloading from web. Now it's impossible for them to
>> test these patchsets because they normally do not subscribe to lkml.
>
>
> from www.kernel.org:
> For comments about the web pages, please send mail to webmaster@kernel.org.
>
> also from www.kernel.org:
> Please don't use finger.kernel.org for any sort of automatic monitoring. The number of automatic bots hitting this port is causing the finger daemon to shut down more often than not. The same information is available from http://www.kernel.org/kdist/finger_banner.
>
> and of course the finger_banner file is not up to date.
>
> You may consider using my http://www.xenotime.net/linux/scripts/kcurrent script.
> Its output (today) is:
>
> The latest stable version of the Linux kernel is:           2.6.30.4
> The latest prepatch for the stable Linux kernel tree is:    2.6.31-rc5
> The latest 2.4 version of the Linux kernel is:              2.4.37.4
> The latest 2.2 version of the Linux kernel is:              2.2.26
> The latest prepatch for the 2.2 Linux kernel tree is:       2.2.27-rc2
> The latest -mm patch to the stable Linux kernels is:        2.6.28-rc2-mm1
> mmotm-2009-0730-0501 ... applies to: 2.6.31-rc4
> next-20090731 ... applies to: v2.6.31-rc4

Thanks randy. Very helpful. But I still have same question. Normal
users need a more convenient and straightforward  way to get what they
want.  It will be better that we put them on www.kernel.org main page,
not only the version info but also the download link.

At least for me when I started my kernel hacking some years ago I
always download kernel from www.kernel.org main page. I'm not sure
whether others people do same thing. Current -next and mmtom are more
like for us to do internal testing.

>
>
> ---
> ~Randy
> LPC 2009, Sept. 23-25, Portland, Oregon
> http://linuxplumbersconf.org/2009/
>



-- 
Regards
dave
