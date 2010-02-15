Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab0BOMZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 07:25:00 -0500
Received: from mail-pz0-f197.google.com ([209.85.222.197]:34196 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab0BOMY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 07:24:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ku87RHxnesyfZ+2lvuPB83p9CsoFmBJrmFjHwdMw/rrAZqm/tNI7RN5V9S/Yj/Z8dS
         Gn+AjF2PavAaP0V/iFswZ6Q/SMO/8Isim5ahwhfdPNTzIMInJ2MGyuvg5o/YYyipDvBB
         VYLbTtlOySTBdNA4m2Edx6v5N4FO07BAxupKo=
Date: Mon, 15 Feb 2010 20:27:32 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: UML error - apps killed 50% of the time
Message-ID: <20100215122732.GM12076@hack.private>
References: <4B78EF9C.6040801@shikadi.net> <20100215090053.GG12076@hack.private> <4B79122A.9070102@shikadi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B79122A.9070102@shikadi.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 15, 2010 at 07:21:46PM +1000, Adam Nielsen wrote:
>>> $ ls
>>> Killed
>>> $ ls
>>> Killed
>>>
>>> vmlinux[6300] general protection eip:b7ea5124 esp:1785bdfc error:0
>>>
>>> Why doesn't UML work any more?
>>
>> http://patchwork.kernel.org/patch/79358/
>>
>> Does this patch help?
>
> Sort of - ls doesn't get killed any more and I can get about half way 
> through the boot process before things start getting killed (as opposed 
> to them getting killed right away.)
>
> Whatever this patch does, if it could do it twice as much then my problem 
> would be solved ;-)
>

So what are the errors now? Could you please provide your boot log?

Thanks.
