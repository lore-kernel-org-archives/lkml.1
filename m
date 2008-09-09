Return-Path: <linux-kernel-owner+w=401wt.eu-S1755796AbYIIFKu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796AbYIIFKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 01:10:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbYIIFKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 01:10:40 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:47414 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820AbYIIFKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 01:10:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=eWrgaURvvawNwa0+jMUqrnY+iynVSkmE+ItpH3S6RiVQui5vypsbHuymOsWuYMHCv4
         U560WRYTOfV4e5PInXOoA3ekeLRdmg4nPCM9cuh5yd+c1iZUnjgvYCZ9gznBjmYQsyDu
         NVffw5ZsVHkrLEGOXjh2HEqHvZhX1NgoJHwpU=
Message-ID: <9929d2390809082210k182280cbpeede915d32212b7f@mail.gmail.com>
Date: Mon, 8 Sep 2008 22:10:37 -0700
From: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
To: "Willy Tarreau" <w@1wt.eu>
Subject: Re: Marvel IDE 88SE6101 2.4.XX support
Cc: ivaylo@bglans.net, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080905123302.GB22545@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.62.0708102357470.24424@mail.bglans.net>
	 <Pine.LNX.4.64.0809042115350.11281@mail.bglans.net>
	 <20080904193625.652bf013@lxorguk.ukuu.org.uk>
	 <20080905040326.GB17104@1wt.eu>
	 <Pine.LNX.4.64.0809051317430.9897@mail.bglans.net>
	 <20080905123302.GB22545@1wt.eu>
X-Google-Sender-Auth: 418abe92290bc531
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2008 at 5:33 AM, Willy Tarreau <w@1wt.eu> wrote:
> Hello,
>
> On Fri, Sep 05, 2008 at 01:37:35PM +0300, ivaylo@bglans.net wrote:
>>
>> Hello,
>>
>> Thanks, Alan for your comment about Marvell PATA IDE driver.
>> In this time I'm a litle bit busy and do not have time to backport driver
>> in 2.4 probably after a time I'll try (I'm not a profesional C programer
>> and it is litle hard to me). I correct generic IDE patch and send you in
>> the attached file.
>
> OK. BTW, next time, please post it in pure text form, so that people on
> the list can easily review and comment it.
>
>> I make also patch to update e1000 driver in the 2.4 kernel to e1000-7.6.5
>> and add support for:
>> 00:19.0 Ethernet controller: Intel Corporation 82801I (ICH9 Family)
>> Gigabit Ethernet Controller (rev 02)
>>
>> But I'm not sure if there are any license violations and any other person
>> who manage network drivers to send it to him. If you know something about
>> it please tell me to send the patch for testing and e.t.c.
>
> Please contact Auke Kok and/or Jesse Brandeburg at intel. They are the
> driver's maintainers, and since they still support it, I do not want to
> change it without their agreement. If they want to propose an upgrade,
> I'll trust them.
>
> Regards,
> Willy
>

Actually Auke is no longer a maintainer for the 10/100/1000/10000 Intel drivers.

Please send your patches to me and Jesse.


-- 
Cheers,
Jeff
