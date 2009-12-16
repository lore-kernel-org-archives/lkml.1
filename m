Return-Path: <linux-kernel-owner+w=401wt.eu-S1761718AbZLPHL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761718AbZLPHL5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760275AbZLPHL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:11:56 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:49452 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756681AbZLPHLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:11:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CsN2AXe1ytiTaM48CzZV1engjpNqfz4H+m2CHFwvkf82oifYgqEQZgcR1lT99YbvY6
         95TBk1ybRipybqj6F5CXs+mtdK+ws9W12209W8TOGBeX936/w1dAc1muUZyEPr9k/i5R
         NG+VuPlqliQ01FuFICMqbAtFkmbQcp1KIzv2I=
Message-ID: <4B288842.5070202@gmail.com>
Date: Tue, 15 Dec 2009 23:12:02 -0800
From: "Justin P. mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Younes Manton <younes.m@gmail.com>
CC: xorg@freedesktop.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [drm] nouveau iMac crashes and burns
References: <dd18b0c30912151454l1aa7fb97g951483993ab42502@mail.gmail.com> 	<586c2acd0912151502o303f6b14g7277289ff5dc69b3@mail.gmail.com> 	<586c2acd0912151508q5361d6a5o12016648935b4eec@mail.gmail.com> 	<4B2870A4.2020202@gmail.com> <586c2acd0912152155w4b19c1d2k5fe7f590060a4b48@mail.gmail.com>
In-Reply-To: <586c2acd0912152155w4b19c1d2k5fe7f590060a4b48@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/09 21:55, Younes Manton wrote:
> On Wed, Dec 16, 2009 at 12:31 AM, Justin P. mattock
> <justinmattock@gmail.com>  wrote:
>> hm.. any ideas i.g.
>> it seems renouveau requirements
>> needs at max 256 mb for memory
>> on the card(and 2.4 kernel),
>>
>> looking at mmiotrace(seems the best way)
>> I've turned on the tracer, but as soon
>> as I load the module nouvaeu the system freezes!
>>
>> Justin P. Mattock
>>
>
> The page you found is for capturing the firmware as Nvidia's driver
> uploads it to the card. We already have your firmware so you don't
> need to do that. Apparently this is one of the integrated chips we
> haven't got working yet so you'll just have to sit tight until someone
> gets their hands on it.
>

Alright..
no worries, more curious if anything.

Justin P. Mattock
