Return-Path: <linux-kernel-owner+w=401wt.eu-S1752126Ab0ABXOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab0ABXOj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 18:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446Ab0ABXOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 18:14:38 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:36319 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0ABXOi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 18:14:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qvqb0W0vsu6G3SgoZP3HmGCuzI1aVTZoXRygHvKJCoq6bhMcln1gCiFvHWq5A/ZSjb
         vfVzTuNJX6TIJ6/yF0jrnYqzlv5gC8iN+b+f5CBm48OgQUB/URoXin66vreUHoEQ8Ctz
         gPZHX62JoglLLl5oXqzlUaU6SJJY16+SqvTDs=
MIME-Version: 1.0
In-Reply-To: <9e4733911001021403n7ba076d0na423ae50e2983171@mail.gmail.com>
References: <523138909@web.de> <20091231131852.GB32492@centrinvest.ru>
	 <20100101001931.GA1290@kroah.com>
	 <1a297b361001020805y6b00af83g81cf8492aa73bc3b@mail.gmail.com>
	 <20100102163449.GB5172@kroah.com>
	 <1a297b361001021017y746e4acdsfcf307b0f363e21d@mail.gmail.com>
	 <9e4733911001021403n7ba076d0na423ae50e2983171@mail.gmail.com>
Date: Sun, 3 Jan 2010 03:14:35 +0400
Message-ID: <1a297b361001021514h19f814d7w586fd0dbb66d98fa@mail.gmail.com>
Subject: Re: [patch staging] BCM70010 (crystalhd) Linux Driver
From: Manu Abraham <abraham.manu@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Greg KH <greg@kroah.com>, Peter Paul <abnominales@web.de>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 3, 2010 at 2:03 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
> On Sat, Jan 2, 2010 at 1:17 PM, Manu Abraham <abraham.manu@gmail.com> wrote:
>> Hi Greg,
>>
>> On Sat, Jan 2, 2010 at 8:34 PM, Greg KH <greg@kroah.com> wrote:
>>> On Sat, Jan 02, 2010 at 08:05:38PM +0400, Manu Abraham wrote:
>>>> Hi Greg,
>>>>
>>>> > I'm glad to do so if someone wants to help work on it there and shephard
>>>> > it into the main kernel tree.
>>>>
>>>> Please find the initial round of cleaned up patches for staging,
>>>> applied against linux-next.
>>>
>>> Did you really author this driver?  If so, that's fine, just checking.
>>> If not, please put the correct authorship "From:" in the patch.
>>
>> I am not the author of the driver. I just picked it up and cleaned it
>> up for Coding style changes for it to be included.
>
> I'm not against this submission, but would it be better to wait until
> Monday when the Broadcom authors are back as see if they want to
> submit their own driver? That way changes would end up back in their
> internal VCS.


Sure, of course,


> I'd like to see a real datasheet for this chip, the public one is
> nothing but a marketing blurb.

You mean a user manual with a description of the registers, don't you ?
Decoder datasheets from whichever manufacturer rarely come into
public. Even with NDA's it is quite hard to get hold of a "proper one"

Regards,
Manu
