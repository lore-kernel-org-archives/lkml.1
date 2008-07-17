Return-Path: <linux-kernel-owner+w=401wt.eu-S1760335AbYGQWJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760335AbYGQWJm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 18:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756410AbYGQWJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 18:09:31 -0400
Received: from hs-out-0708.google.com ([64.233.178.250]:44911 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006AbYGQWJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 18:09:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ORFtqB67les8pKAHgA3BwTFjeTHJ22ItaNvfOHLkoHTXjlfmY+0A4Mk0EpEDw8DLW6
         /DvhVCgBIAaSD9n7rkM3GGg1sqMpg5HL3NIayLiYUwyC0uAVg/x/GvzQbe+LhtG9fbtv
         sqCjhT+g5IUQD22n5gEZbcWfq74bkTg7YVbBw=
Message-ID: <dd18b0c30807171509j5801ac92tdaaca72a4094ffc@mail.gmail.com>
Date: Thu, 17 Jul 2008 22:09:27 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Jack Howarth" <howarth@bromo.msbb.uc.edu>
Subject: Re: 2.6.26-rc9-git9 doesn't boot on Macintel
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080717195039.GA28694@bromo.msbb.uc.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440807161749u2f5c1eben618e05c6e254fedd@mail.gmail.com>
	 <86802c440807161959s10666027k5297af1d657ff4fa@mail.gmail.com>
	 <20080717034418.GA18951@bromo.msbb.uc.edu>
	 <86802c440807162113g4cea3bd9ic71210330417032b@mail.gmail.com>
	 <20080717061825.GA19582@bromo.msbb.uc.edu>
	 <86802c440807162348m6d05b912x7b3f655d7f9efb93@mail.gmail.com>
	 <20080717162622.GA26835@bromo.msbb.uc.edu>
	 <86802c440807170942k387c7d73o838584d99457bd30@mail.gmail.com>
	 <dd18b0c30807171139r77caf0d5vee7c6eff1a6b9157@mail.gmail.com>
	 <20080717195039.GA28694@bromo.msbb.uc.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 7:50 PM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
> Justin,
>    Could you try booting either the current i386 or x86_64
> boot.iso from fedora development. If you select the linux rescue
> mode, it will likely crash before the kernel fully loads. However,
> it would be useful to be able to see if Fedoras config for
> 2.6.26 behaves the same way. That is do you see a kernel panic
> or what I see which is a system freeze. Thanks in advance.
>            Jack
> ps Does vga=794 work okay under 2.6.26 for you? That kernel option
> works fine for me under 2.6.25.10 to provide a higher resolution
> display (so that I can see more of the boot messages). However under
> 2.6.26, vga=794 just shows a black screen. Weird.
>
>
> On Thu, Jul 17, 2008 at 06:39:55PM +0000, Justin Mattock wrote:
>> On Thu, Jul 17, 2008 at 4:42 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> > On Thu, Jul 17, 2008 at 9:26 AM, Jack Howarth <howarth@bromo.msbb.uc.edu> wrote:
>> >> YH,
>> >>   I am wondering if it might be worthwhile for me to
>> >> try the various rc releases of 2.6.26 (starting with rc1-git1)
>> >> to see if I can identify at what point 2.6.26 was broken
>> >> with regards to booting on my MacBook Pro? In case that
>> >> would point us towards the checkin of a specific set of
>> >> patches as the problem.
>> >
>> > try 2.6.26-rc1,..rc2
>> >
>> > YH
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > Please read the FAQ at  http://www.tux.org/lkml/
>> >
>>
>> O.K. I tried MMCONFIG and it seems
>> to be giving me a: kernel panic
>> VFS: cannot open device sda1 or unkown block (0,0)
>>
>> from what I remember I noticed this as far back as 2.6.22
>>
>> --
>> Justin P. Mattock
>

when sending the post make sure you select reply toall
this way all of the cc's are there.(just in case you didn't know)
you're going to have to give me that address again,
deleted all of my messages this morning without thinking about it.

-- 
Justin P. Mattock
