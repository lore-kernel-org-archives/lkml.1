Return-Path: <linux-kernel-owner+w=401wt.eu-S1757134AbZFXXtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757134AbZFXXtc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 19:49:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756962AbZFXXtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 19:49:19 -0400
Received: from mail-fx0-f213.google.com ([209.85.220.213]:37059 "EHLO
	mail-fx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbZFXXtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 19:49:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NTJ4VkLQm3eHql/G350pN+XLbjTJ17JY0bJL97Li+F9kelqie8El2mdtmRc8wmkL2M
         TDPhOQXlrvkboOO+TBZkvqs4YtL6LULNzIU0qUhlnGC2IeTm/QLTg9GlvwoZqnZonu8M
         pIJcs7oCw2a98waNrTYgvHcOTSTjGlTfZKp/U=
MIME-Version: 1.0
In-Reply-To: <4A42AD76.8040303@bluewatersys.com>
References: <4A3F017B.2010409@bluewatersys.com>
	 <63386a3d0906220122x31d0b23fk7bd86145b719d9b5@mail.gmail.com>
	 <4A3FFE02.8020001@bluewatersys.com>
	 <63386a3d0906230004m66360f4fhbdc80c8e552a01d0@mail.gmail.com>
	 <4A413F8F.6030500@bluewatersys.com>
	 <63386a3d0906241543n16da1f0gc988738f9efd8782@mail.gmail.com>
	 <4A42AD76.8040303@bluewatersys.com>
Date: Thu, 25 Jun 2009 01:49:21 +0200
Message-ID: <63386a3d0906241649l60142ea2j1a608ce27c0f65cc@mail.gmail.com>
Subject: Re: [PATCH] SST25L (non JEDEC) SPI Flash driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       spi-devel-general@lists.sourceforge.net, mike@steroidmicros.com,
       linux kernel <linux-kernel@vger.kernel.org>, dedekind@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/25 Ryan Mallon <ryan@bluewatersys.com>:
> Linus Walleij wrote:
>> 2009/6/23 Ryan Mallon <ryan@bluewatersys.com>:
>>
>>> BTW, most of my other patches go via the ARM list, which uses the patch
>>> system. Whats the procedure for most other lists, do patches just get
>>> collected by the subsection maintainer when they are okay?
>>
>> That's the most typical procedure, however I think the SPI maintainer
>> (David) has been busy with other things so I merged the PL022
>> driver through the ARM tree instead. Another possibility is to send
>> it off to Andrew Mortons tree I guess.
>
> Can I get your acked-by and then just CC Andrew Morton?

I'm not much of a stakeholder in the SPI subsystem, but FWIW:
Acked-by: Linus Walleij <linus.walleij@stericsson.com>

Yours,
Linus Walleij
