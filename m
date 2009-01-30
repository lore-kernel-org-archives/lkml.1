Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZA3Cer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZA3Cer (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 21:34:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751656AbZA3Cei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 21:34:38 -0500
Received: from mail.lang.hm ([64.81.33.126]:38022 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489AbZA3Ceh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 21:34:37 -0500
Date: Thu, 29 Jan 2009 19:38:18 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Bill Davidsen <davidsen@tmr.com>
cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Switching from (deprecated) IDE driver -> SATA (PATA support)
In-Reply-To: <498240B7.6010500@tmr.com>
Message-ID: <alpine.DEB.1.10.0901291937290.24753@asgard.lang.hm>
References: <alpine.DEB.1.10.0901250553430.2441@p34.internal.lan> <200901252027.43376.bzolnier@gmail.com> <alpine.DEB.1.10.0901251612310.16676@p34.internal.lan> <200901252239.26268.bzolnier@gmail.com> <498240B7.6010500@tmr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009, Bill Davidsen wrote:

>>>> 
>>> Correction, it was the HPT controller as you noted, broken? Was working 
>>> for me in 2.6.26.3 :)
>>> 
>>> CONFIG_BLK_DEV_HPT34X=y
>>> # CONFIG_HPT34X_AUTODMA is not set
>>> CONFIG_BLK_DEV_HPT366=y
>> 
>> HPT34X driver got removed not HPT366.
>> 
>> However if you need we can bring support for HPT34x hardware back. :)
>
> I don't think "bring it back" is enough, it had some major issues as I 
> recall. I actually have a pile of these, but not running any recent kernel.
>

what was the problem with these? I have somthing in this family in one of 
my secondary boxes (I'd have to go check exactly which model)

David Lang
