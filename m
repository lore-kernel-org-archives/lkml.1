Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751065Ab0BGFH2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Feb 2010 00:07:28 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:58066 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab0BGFH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Feb 2010 00:07:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=UvasvlJaLNBY8XtG7a+UDOy7S+1K0dNFZ2c3d5R63w2RtR7KEirgJQZTuADgOOPEhk
         zIO3lcULl3pWqcPoXfLkuErxehwTbImYRdpo5DUdKOqgOZ95S7PsH/l4gJrEkh1m4j6A
         WUwuiWwCArT0pkook484gEkVnyJGVSsy5xjCc=
Message-ID: <4B6E4AF2.8080603@gmail.com>
Date: Sat, 06 Feb 2010 21:09:06 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain> <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain> <4B6E4793.3010201@teksavvy.com>
In-Reply-To: <4B6E4793.3010201@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/10 20:54, Mark Lord wrote:
> Linus Torvalds wrote:
>> Do people really care about the old-fashioned tar.gz and patch.gz
>> files? I've always uploaded the tar-files and patches compressed with
>> gzip, because that's the "traditional" way, and then we have a script
>> that also re-compresses things as 'bz2' because it compresses better
>> and many people are bandwidth-limited and much prefer the better
>> compression.
> ..
>
> I prefer the .gz files, despite limited bandwidth here.
> My older, slower CPUs cope with them better.
>
> But .bz2-only would be fine as well.
>
> I just wish the GNU tar folk had the sense to combine -z and -j
> into a single flag.
>
> -ml
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>

what about the new lz thing?
(heck haven't even figured that out yet).

Justin P. Mattock
