Return-Path: <linux-kernel-owner+w=401wt.eu-S1754554AbZFDShq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbZFDShq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 14:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZFDShK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 14:37:10 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56610 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbZFDShJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 14:37:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fnCesJGzk95zMV5UwAaapatQKqFKSUBJJ4joZoaD56UnTHuNDH8E8QeZGSAGY82Ndk
         UcFfeZMdPyjX9IJr530yAT3ThHiBWqjR93/wXB82PPqnmOkPeQEX9oQzLCK11v08SaXg
         4HYfMkOdtSa9aeW988jsb9zUv+nS6y/Jz1He0=
MIME-Version: 1.0
In-Reply-To: <4A27616C.6030802@gmail.com>
References: <430c80e90905290054n7416802cq7128394db5de036d@mail.gmail.com>
	 <20090602214745.GB25921@kroah.com>
	 <430c80e90906022349l6fa7a9b4lb73f0ab1980b3e63@mail.gmail.com>
	 <20090603152152.GB25560@kroah.com> <4A27616C.6030802@gmail.com>
Date: Thu, 4 Jun 2009 20:37:10 +0200
Message-ID: <ca2dc2820906041137m2075ae1bye03c08fc1b5c0368@mail.gmail.com>
Subject: Re: [TRIVIAL][PATCH 1/1] Fix warning in staging/otus/ioctl.c
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Pranith Kumar <pranith.hacks@gmail.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 4, 2009 at 7:53 AM, Pranith Kumar <pranith.hacks@gmail.com> wrote:
> Greg KH wrote:
>>
>> On Wed, Jun 03, 2009 at 12:19:26PM +0530, Pranith Kumar wrote:
>>
>>>
>>> I am using Gmail, which does this. I haven't figured out how to
>>> configure this thing yet.
>>>
>>
>> Please try reading Documentation/email-clients.txt and try again.
>>
>>
>
> Ok, I've configured my email client now. Resubmitting patch.
>

Here is a tip: Submit the patch to yourself first, then use the
GMail's option "See original" and check if your patch is linewrapped.
After being sure that your patch is not linewrapped, send it to LKML.

That is what I did while finding a decent email client : )

PS: Do not forget to repeat the process every time you configure a new
email client!
