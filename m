Return-Path: <linux-kernel-owner+w=401wt.eu-S1759301AbYGQO2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301AbYGQO2N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 10:28:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbYGQO16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 10:27:58 -0400
Received: from wx-out-0506.google.com ([66.249.82.237]:59670 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640AbYGQO15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 10:27:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O+WQcssMHHk+DzwyYKNb8xZok1DbnIxF0Zn4cnAOUEIhvp7aVPn4ewv3TkvMmPg+Oz
         PkdhsYYpyUFn5SFoUmLMM79abuTs2TJ189IXC0VO83HGPLRSM50ylnN/k/VRplawFruk
         MDTT17bVbr06WwBQ6MU66vxpOPKC+JqsRpdTs=
Message-ID: <dd18b0c30807170727t4c20eb32v5e6378d844ae0376@mail.gmail.com>
Date: Thu, 17 Jul 2008 14:27:56 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "el es" <el_es_cr@yahoo.co.uk>
Subject: Re: Kernel version : what about s.yy.ww.tt scheme ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <loom.20080717T100809-415@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <loom.20080717T083755-676@post.gmane.org>
	 <alpine.LNX.1.10.0807171140030.18697@fbirervta.pbzchgretzou.qr>
	 <loom.20080717T100809-415@post.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 10:38 AM, el es <el_es_cr@yahoo.co.uk> wrote:
> Jan Engelhardt <jengelh <at> medozas.de> writes:
>
>> >The scheme to be s.yy.ww.tt, that is :
>> >
>> >s - series, as it is now (freedom to Linus to bump it to 3 when BKL is removed
>> >for example ;) )
>> >yy - two (in a hundred years, three) digits of the year
>> >Now the interesting part begins which is
>> >ww - the number of the week of the release. This will be between 1 and 52 (53)
>> >tt - the number of the week of stable release. As above.
>>
>> Interesting idea.
>>
>
> Thanks :)
>
>> -stable usually overlaps with master. But I don't like version
>> numbers long as binutils and "2.8.30.9.01" have.
>
> Yes, master and stable accumulate the same patches, I know. Only master takes
> new code, whereas -stable does not.
>
> This however tells how long did it take to produce the -stable release out of
> Linus's release ;) And it does not break the current habits - just abuses them a
> bit ;)
> And tells you how long the version was around there without another -stable
> release too. Just by looking onto the version string, quick, sortable in
> meaningful way, all sorts of pluses there ;)
>
> IMO, the kernel is so mature already, and the development is so fast, and the
> changes not always so fundamental, that the version in the old sense becomes
> irrelevant - it is not the 2.4->2.6 transition days any more ;)
>
>
>
> Regards,
> Lukasz (btw sorry I forgot to sign myself last time ;)
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

What about how porsch does it
i.g. 911, 912, 913, 914

-- 
Justin P. Mattock
