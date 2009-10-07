Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbZJGVco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbZJGVco (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 17:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753356AbZJGVco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 17:32:44 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:37309 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbZJGVcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 17:32:43 -0400
MIME-Version: 1.0
In-Reply-To: <20091007211916.GA4217@kroah.com>
References: <f3f71ab90910071414n482eca2dm18108c79ee08028d@mail.gmail.com> 
	<20091007211916.GA4217@kroah.com>
From: Mike Lothian <mike@fireburn.co.uk>
Date: Wed, 7 Oct 2009 22:31:44 +0100
Message-ID: <f3f71ab90910071431g524fa807ib67f5fcfef7c70d1@mail.gmail.com>
Subject: Re: Samsung Backlight Patch
To: Greg KH <greg@kroah.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Matthias Hopf <mhopf@suse.de>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/7 Greg KH <greg@kroah.com>:
> On Wed, Oct 07, 2009 at 10:14:37PM +0100, Mike Lothian wrote:
>> Hi
>>
>> I was hoping the following patch could be included in 2.6.32 so it
>> would hopefully end up in the next round of distros
>>
>> It adds backlight support for some Samsung laptops
>
> You seem to have lost the original authorship of this patch, and not
> included your signed-off-by for it.
>
> Which means it can't be applied :(
>
> thanks,
>
> greg k-h
>

It definitely has +MODULE_AUTHOR("Greg Kroah-Hartman
<gregkh@suse.de>"); at the bottom

I certainly wasn't trying to steal credit for your work

Who should sign it off?

I think there's a few other models that can be added to this patch too

Regards

Mike
