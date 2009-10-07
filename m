Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZJGXdZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZJGXdZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:33:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755485AbZJGXdY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:33:24 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:44132 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZJGXdY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:33:24 -0400
MIME-Version: 1.0
In-Reply-To: <20091007225828.GA7892@kroah.com>
References: <f3f71ab90910071414n482eca2dm18108c79ee08028d@mail.gmail.com> 
	<20091007211916.GA4217@kroah.com> <f3f71ab90910071431g524fa807ib67f5fcfef7c70d1@mail.gmail.com> 
	<20091007225828.GA7892@kroah.com>
From: Mike Lothian <mike@fireburn.co.uk>
Date: Thu, 8 Oct 2009 00:31:51 +0100
Message-ID: <f3f71ab90910071631g2ffb4796u6a3a370252c4cf92@mail.gmail.com>
Subject: Re: Samsung Backlight Patch
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Matthias Hopf <mhopf@suse.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/7 Greg KH <greg@kroah.com>:
> On Wed, Oct 07, 2009 at 10:31:44PM +0100, Mike Lothian wrote:
>> 2009/10/7 Greg KH <greg@kroah.com>:
>> > On Wed, Oct 07, 2009 at 10:14:37PM +0100, Mike Lothian wrote:
>> >> Hi
>> >>
>> >> I was hoping the following patch could be included in 2.6.32 so it
>> >> would hopefully end up in the next round of distros
>> >>
>> >> It adds backlight support for some Samsung laptops
>> >
>> > You seem to have lost the original authorship of this patch, and not
>> > included your signed-off-by for it.
>> >
>> > Which means it can't be applied :(
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>>
>> It definitely has +MODULE_AUTHOR("Greg Kroah-Hartman
>> <gregkh@suse.de>"); at the bottom
>>
>> I certainly wasn't trying to steal credit for your work
>
> I mean on the patch, when submitting it, you need a:
>        From: Greg Kroah-Hartman <gregkh@suse.de>
>
> as the first line.
>
>> Who should sign it off?
>
> As I stated before, I can not sign off on this patch anymore, but I
> would like my authorship to remain.  Someone needs to sign off on it...
>
>> I think there's a few other models that can be added to this patch too
>
> I do too.
>
> Note, if you look at the git tree I have for the driver, it is totally
> rewritten to not use a structure, and instead, use offsets properly.
> But it removed support for your laptop, which is not what you probably
> want :(
>
> thanks,
>
> greg k-h
>

What git tree?
