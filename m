Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933907Ab0BQBuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 20:50:17 -0500
Received: from mail-iw0-f185.google.com ([209.85.223.185]:35867 "EHLO
	mail-iw0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933336Ab0BQBuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 20:50:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=IbY3QajqQm3WGIbPx9wxskrFlYH682iayu+Lb2fCL+/MU57UGuABoCTN2bj1VSMZvi
         LDvMka4XGuFGbD6Isf8lsI4XnhTLgebTOTFVjSknQuAxP3TUKfsDAH84phR7HFr0HjHP
         tI9ETrYKNORltoVcO2/0o4A7Whl449guqFpoY=
MIME-Version: 1.0
In-Reply-To: <4B4668F7.1000304@zytor.com>
References: <1262847894-27498-1-git-send-email-airlied@gmail.com>
	 <4B4668F7.1000304@zytor.com>
Date: Wed, 17 Feb 2010 11:50:14 +1000
Message-ID: <21d7e9971002161750j25c28e22ged6eb6edea7d2b5c@mail.gmail.com>
Subject: Re: [PATCH] x86: allow fbdev primary video code on 64-bit.
From: Dave Airlie <airlied@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-fbdev-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Dave Airlie <airlied@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 8, 2010 at 9:06 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/06/2010 11:04 PM, Dave Airlie wrote:
>> From: Dave Airlie <airlied@redhat.com>
>>
>> For some reason the 64-bit tree was doing this differently and
>> I can't see why it would need to.
>>
>> This correct behaviour when you have two GPUs plugged in and
>> 32-bit put the console in one place and 64-bit in another.
>>
>> Signed-off-by: Dave Airlie <airlied@redhat.com>
>
> Looks good... I presume this is for .34, though?

Is this queued? I've been told its not showing up in linux-next.

Dave.
