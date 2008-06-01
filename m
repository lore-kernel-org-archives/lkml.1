Return-Path: <linux-kernel-owner+w=401wt.eu-S1752792AbYFATho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792AbYFATho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 15:37:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYFAThf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 15:37:35 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:14541 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294AbYFAThe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 15:37:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Z12MhtPjOMIbLZDMQRPI6okBhVcRlJhWAKfxt/lIyYM0BYFyGrF6RxFOv8NAbaxLolkKI7KKY0RFRq3UvI+eIltyJNux1fiAD9ohP1EfSDlmizDz3ZRHx8UW88uDNlWWlhPjCY/h808w2N55RyJZJFwcIdmY75OpVdXB+ItAYSQ=
Message-ID: <dd18b0c30806011237v129990ddud066b603bf66cfcd@mail.gmail.com>
Date: Sun, 1 Jun 2008 19:37:33 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Oliver Neukum" <oliver@neukum.org>
Subject: Re: [Bug #10825] appletouch after wakeup
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200806012029.09618.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	 <dd18b0c30806011020i5f878f77qff504ffbe351b835@mail.gmail.com>
	 <dd18b0c30806011125o1053171aged053f9a35f0de5a@mail.gmail.com>
	 <200806012029.09618.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 1, 2008 at 6:29 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Sonntag, 1. Juni 2008 20:25:03 schrieb Justin Mattock:
>> On Sun, Jun 1, 2008 at 5:20 PM, Justin Mattock <justinmattock@gmail.com> wrote:
>> > On Sun, Jun 1, 2008 at 10:40 AM, Oliver Neukum <oliver@neukum.org> wrote:
>> >> Am Sonntag, 1. Juni 2008 01:21:44 schrieb Justin Mattock:
>> >>>  { USB_DEVICE(0x05ac, 0x021a), .driver_info = USB_QUIRK_RESET_RESUME },
>> >>
>> >> This one.
>> >>
>> >>        Regards
>> >>                Oliver
>> >>
>> >
>> > Cool, I'll give it a go.
>> > regards;
>> >
>> > --
>> > Justin P. Mattock
>> >
>>
>> gripes; It seems appletouch is still tripping out upon wakeup.
>> regards;
>>
>
> Please also apply the patch from the following link:
> https://bugzilla.novell.com/attachment.cgi?id=213908
>
>        Regards
>                Oliver
>
>

Alright; I'll let you know what happens.
regards;


-- 
Justin P. Mattock
