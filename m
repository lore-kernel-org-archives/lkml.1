Return-Path: <linux-kernel-owner+w=401wt.eu-S1752391AbYI3EVB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbYI3EVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 00:21:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYI3EUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 00:20:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:24612 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbYI3EUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 00:20:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=McrUaNTP4ktVkMt3ChJoyxO3WzgDC7+8WJOWlMUwEM1n2PmRFpEBVE6ZqXyqasWIOT
         RgQoicxSehP5qkzQrn17x+YmF8FRVZ3cU6ML4Vn9ueWExyVWPEu/klf0BmY+WMuELHL4
         7bM4HvKJ1/e7AW7r9Af4yfxB/4fHqQHSYfN/Y=
Message-ID: <aa79d98a0809292120n65bbe2c4ye2eae7504694f77f@mail.gmail.com>
Date: Tue, 30 Sep 2008 08:20:49 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Grant Grundler" <grundler@parisc-linux.org>
Subject: Re: [PATCH 7/7] x86: print out irq nr for msi/ht -v2
Cc: "Jesse Barnes" <jbarnes@virtuousgeek.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Yinghai Lu" <yinghai@kernel.org>, "Len Brown" <lenb@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       linux-acpi@vger.kernel.org
In-Reply-To: <20080929195741.GB14409@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222323223-23529-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080927185306.GA18619@elte.hu> <20080927190237.GD10186@localhost>
	 <200809291005.04941.jbarnes@virtuousgeek.org>
	 <20080929172928.GC7360@localhost>
	 <20080929195741.GB14409@colo.lackof.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2008 at 11:57 PM, Grant Grundler
<grundler@parisc-linux.org> wrote:
> On Mon, Sep 29, 2008 at 09:29:28PM +0400, Cyrill Gorcunov wrote:
>> [Jesse Barnes - Mon, Sep 29, 2008 at 10:05:02AM -0700]
>> | On Saturday, September 27, 2008 12:02 pm Cyrill Gorcunov wrote:
>> | > [Ingo Molnar - Sat, Sep 27, 2008 at 08:53:06PM +0200]
>> | >
>> | > ...
>> | >
>> | > A bit offtopic...well...completely offtopic I would say :)
>> | >
>> | > Ingo maybe you have any PCI specs? I've asked several people
>> | > for this. Peter adviced to ask HW vendors but I don't have
>> | > friends who has access to a such docs. Evgeniy Polyakov
>> | > promised to ask someone but I think there will not be success
>> | > too :(. I'll ask Maciej too later since now he seems to be
>> | > quite busy.
>> |
>> | I think if you use google you can find the PCI spec in pdf form (search for
>> | pci pdf probably).
>
> Not probably. You will find them that way.
>
> It is illegal for anyone to redistribute PCISIG copyrighted documents.
> That hasn't stopped it from happening. I've pointed this out in the past
> (and got a polite "please don't point that out again publicly").
> I'm glad Jesse did instead. :)
>
>>   The MindShare books are also quite good, and cover PCI,
>> | PCI-X, and PCI Express in great detail (far more readable than the spec too).
>
> +1
>
> grant
>
>> |
>> | --
>> | Jesse Barnes, Intel Open Source Technology Center
>> |
>>
>> Thanks for reply, Jesse! Of course I could use google. But actually
>> the only think I found is version 2.2 (which is a bit old). Will take
>> a look if I could buy this book (not sure if it may be done here). PCI
>> membership is quite expencive for me that is why I was asking for this
>> documents in private mails I sent before. I don't like to behave like
>> that but just had to.
>>
>>               - Cyrill -

Yes, the only acceptable solution is to buy one of these books - I've found
one in a local online shop. So I have no rights to ask such a question neither
I should. Actually it's a good example of _bad_ behaviour absolutely non-
acceptable in LKML!!! My apologizes!
