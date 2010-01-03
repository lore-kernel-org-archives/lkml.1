Return-Path: <linux-kernel-owner+w=401wt.eu-S1750981Ab0ACF6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750981Ab0ACF6O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 00:58:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750846Ab0ACF6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 00:58:14 -0500
Received: from mail-yw0-f113.google.com ([209.85.211.113]:35998 "EHLO
	mail-yw0-f113.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839Ab0ACF6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 00:58:13 -0500
X-Greylist: delayed 2982 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Jan 2010 00:58:13 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=Vk4zS7grK5opsL6OuRS8mJ0YI7oY4LbmrMjnakZZ3WIgUH7X/L6AsmaVcENxM4qU2M
         GnwpvQ/v+3VWESv6CyIRauMm3K08iR0e5oga6Csj3U0rgeDwTi58z/V+qZ9KSPy3n+zV
         l3kG3WJhuPqRGCLHZjlwl3RiUpq5CzayK+yFA=
MIME-Version: 1.0
Reply-To: jarod@wilsonet.com
In-Reply-To: <9e4733911001021403n7ba076d0na423ae50e2983171@mail.gmail.com>
References: <523138909@web.de> <20091231131852.GB32492@centrinvest.ru>
	 <20100101001931.GA1290@kroah.com>
	 <1a297b361001020805y6b00af83g81cf8492aa73bc3b@mail.gmail.com>
	 <20100102163449.GB5172@kroah.com>
	 <1a297b361001021017y746e4acdsfcf307b0f363e21d@mail.gmail.com>
	 <9e4733911001021403n7ba076d0na423ae50e2983171@mail.gmail.com>
Date: Sat, 2 Jan 2010 23:51:23 -0500
Message-ID: <7cdf10991001022051k2c8454c1q5cffb955e901e58a@mail.gmail.com>
Subject: Re: [patch staging] BCM70010 (crystalhd) Linux Driver
From: Jarod Wilson <jarodwilson@gmail.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Manu Abraham <abraham.manu@gmail.com>, Greg KH <greg@kroah.com>,
       Peter Paul <abnominales@web.de>, linux-kernel@vger.kernel.org,
       davilla@4pi.com, Jarod Wilson <jarod@wilsonet.com>,
       nsankar@broadcom.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 2, 2010 at 5:03 PM, Jon Smirl <jonsmirl@gmail.com> wrote:
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

Yes, please hold off a bit on this, I've actually been working on this
driver with Scott and Naren (cc'd) for several months now (which is
part of why it doesn't look so much like a lot of typical vendor code
;), and was planning to handle the submission on Naren and Broadcom's
behalf. Just didn't expect someone else to hop on it this quickly. Was
planning to get a git tree up on git.kernel.org over the weekend for
both the driver and the lib, start prepping patches for review, etc.,
but family time and home improvement projects have taken precedence
the past few days (not to mention a few other driver projects that
sucked up time earlier in the break, *cough* IR).

-- 
Jarod Wilson
jarodwilson@gmail.com
