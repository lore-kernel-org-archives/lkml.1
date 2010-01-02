Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126Ab0ABWDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab0ABWDw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 17:03:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657Ab0ABWDw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 17:03:52 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:56191 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab0ABWDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 17:03:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UICsxihRc4FK8/82Tg9btMrWbEZn5/1CUSXGMXrxcOSErOJJ5FAUoVbfl/h8egGt94
         u7oidrW6S6TLy22ra3CsIjzkNmWR8z5RFh2Xqdi26pgrnCnP2bFM5Oacu4Ju2Ampy34a
         CuskTMQ8uRv8a+r7ngZLzAvru56DJ7Ojfe2Fc=
MIME-Version: 1.0
In-Reply-To: <1a297b361001021017y746e4acdsfcf307b0f363e21d@mail.gmail.com>
References: <523138909@web.de> <20091231131852.GB32492@centrinvest.ru>
	 <20100101001931.GA1290@kroah.com>
	 <1a297b361001020805y6b00af83g81cf8492aa73bc3b@mail.gmail.com>
	 <20100102163449.GB5172@kroah.com>
	 <1a297b361001021017y746e4acdsfcf307b0f363e21d@mail.gmail.com>
Date: Sat, 2 Jan 2010 17:03:50 -0500
Message-ID: <9e4733911001021403n7ba076d0na423ae50e2983171@mail.gmail.com>
Subject: Re: [patch staging] BCM70010 (crystalhd) Linux Driver
From: Jon Smirl <jonsmirl@gmail.com>
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Greg KH <greg@kroah.com>, Peter Paul <abnominales@web.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 2, 2010 at 1:17 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
> Hi Greg,
>
> On Sat, Jan 2, 2010 at 8:34 PM, Greg KH <greg@kroah.com> wrote:
>> On Sat, Jan 02, 2010 at 08:05:38PM +0400, Manu Abraham wrote:
>>> Hi Greg,
>>>
>>> > I'm glad to do so if someone wants to help work on it there and shephard
>>> > it into the main kernel tree.
>>>
>>> Please find the initial round of cleaned up patches for staging,
>>> applied against linux-next.
>>
>> Did you really author this driver?  If so, that's fine, just checking.
>> If not, please put the correct authorship "From:" in the patch.
>
> I am not the author of the driver. I just picked it up and cleaned it
> up for Coding style changes for it to be included.

I'm not against this submission, but would it be better to wait until
Monday when the Broadcom authors are back as see if they want to
submit their own driver? That way changes would end up back in their
internal VCS.

I'd like to see a real datasheet for this chip, the public one is
nothing but a marketing blurb.


>
>> Also, please break up patches to be sent one-per-email so they can be
>> properly applied, and also only have them do one thing (your 4th patch
>> fixed up coding style issues and added the driver to the build.)
>
> Okay, I will resend them.
>
>> Also, can you add a TODO file to the driver directory stating what is
>> needed to be done, and who to contact about it?
>
> I will test the device over the coming week and add in a TODO after that.
>
> Thanks,
> Manu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Jon Smirl
jonsmirl@gmail.com
