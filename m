Return-Path: <linux-kernel-owner+w=401wt.eu-S1756404AbZLCRx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756404AbZLCRx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:53:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756361AbZLCRx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:53:57 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:37238 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756321AbZLCRxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:53:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZuvmG8pIzpElGOOxiMA5wZkNY4OpQnSfWT2cpr+QY4p7iljf5+YG9K44tC+GLlXL3l
         ZVVUBRi8PWxJ6osW/ugUJ20DGuAHAYHEkESJ7ctXBK86WkAHry9KKR3uxUP78+WEN7WM
         K1ZW/VXHV6fmFsEEctGeuZpPznLn43x6USw9s=
Message-ID: <4B17FB37.2030501@garzik.org>
Date: Thu, 03 Dec 2009 12:53:59 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost> <4B1771CD.3090409@garzik.org> <200912031339.14440.bzolnier@gmail.com>
In-Reply-To: <200912031339.14440.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 07:39 AM, Bartlomiej Zolnierkiewicz wrote:
> On Thursday 03 December 2009 09:07:41 am Jeff Garzik wrote:
>> The merge window is upon us, which by strict rules means that anything
>> not already in libata-dev.git#upstream needs to wait until 2.6.34.
>>
>> However, bug fixes and the like should definitely be in 2.6.33.
>> ->init_host is definitely 2.6.34 material.  Some of the other stuff
>> could go either way.

> If you would like to apply some of my patches to 2.6.33 you are more than
> welcome to do it.  I can even prepare separate git tree with specific changes
> to make it easier for you once you tell me which changes you would like to
> see in it.

OK, great.

Can you prepare a patchset containing only fixes?  Comment-only changes 
are acceptable too.  Trivial changes too, if they are extremely trivial :)

Include nothing that adds features, removes or unifies drivers, etc.

Please do it in standard kernel submit form, which is either
(a) repost the patches (yes, again) being submitted for 2.6.33, or
(b) a standard git pull request, which includes shortlog, diffstat, and 
all-in-one diff.

	Jeff


