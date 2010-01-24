Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166Ab0AXFFt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab0AXFFt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 00:05:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751433Ab0AXFFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 00:05:47 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52124 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab0AXFFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 00:05:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=LNWV7jiCyxF0yubJ6m2S4DRokfYqug3/uO2Bmbg1aOpJu/gyKXzjA0B7vdFxDDioas
         IJwELa5MHasYEld9NydBsxwuffSS1InqUAKtXUIe5CwxlXzVz1VnKkhiDKPfYvKqL0CU
         QII7WBOtzPSEgUYJmmbE/Lvz9c9HF3Up03fAc=
MIME-Version: 1.0
In-Reply-To: <4B5B38C1.5080109@hhs.nl>
References: <3f9a31f41001230952g6321c47bq9baf5dcfdfaf5b59@mail.gmail.com>
	 <4B5B38C1.5080109@hhs.nl>
Date: Sun, 24 Jan 2010 10:35:45 +0530
Message-ID: <3f9a31f41001232105l58d36ffdp8d06231f524a98ec@mail.gmail.com>
Subject: Re: [lm-sensors] Status of Andigilog asc7621 driver submitted by 
	George Joseph on 2008-05-29
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
Cc: George Joseph <George.joseph@fairview5.com>, lm-sensors@lm-sensors.org,
       Jean Delvare <khali@linux-fr.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Hans,

On Sat, Jan 23, 2010 at 11:28 PM, Hans de Goede <j.w.r.degoede@hhs.nl> wrote:
> Hi,
>
> On 01/23/2010 06:52 PM, Jaswinder Singh Rajput wrote:
>>
>> Andigilog asc7621 driver submitted by George Joseph on 2008-05-29,
>> This chip is used by various Intel Motherboards.
>>
>> Is it still under review and testing :
>>
>> http://lists.lm-sensors.org/pipermail/lm-sensors/2008-May/023257.html
>>
>> http://www.spinics.net/lists/lm-sensors/msg26915.html
>>
>> http://www.spinics.net/lists/lm-sensors/msg26916.html
>>
>> http://www.lm-sensors.org/wiki/Devices
>>
>
> I guess this is partly my fault, I started a review but never finished
> it. One of the big problems is that George did many things completely
> different to how every other single hwmon driver does things. Which made
> the review harder then necessary, and more over made me wonder if we
> should accept the driver in that incarnation at all.
>

George Joseph submitted the driver on 2008-05-29 and then he updated
the driver on 2009-10-15 for 2.6.30 and many developers are able to
test it and used it.

Are you able to compile the driver with latest kernel git.

> Then a lot of things happened and I never got around to doing anything
> with it at all.
>

Many new Intel Motherboards are coming with this chip, if we complete
this driver then it will be great.

> I just checked my Drafts folder, and I still have my unfinished review
> in there. So if there is interest I can send that, note that it is
> not a complete review though (there is a note in there which part
> of the code is reviewed and which still needs to be reviewed).
>

Please provide your review so that we can discuss about this driver
and make relevant changes to accept it.

Thank you,
--
Jaswinder Singh.
