Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYKZIyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYKZIyq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 03:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbYKZIyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 03:54:37 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:59212 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbYKZIyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 03:54:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=N5AEDqFHXJaVLZf9zCCFcmP9/JPFUjUZm4Pp8lgsIJvnvGc1oeci8JOu5WJ/WLcWXM
         rRrpdd+/w1BXC6DhYbWS1prVH0Zv2KZzbePBsYnn+7rO/ikCQNrNzdt6dfcPO5nOjzDR
         r5nsatTAEyoOGbbHP6l87dkLdSyGMCKCx9qtg=
Message-ID: <7c86c4470811260054s2652e648i7ba44796bc40c424@mail.gmail.com>
Date: Wed, 26 Nov 2008 09:54:34 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "David Miller" <davem@davemloft.net>
Subject: Re: [patch 01/24] perfmon: generic headers
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, andi@firstfloor.org, sfr@canb.auug.org.au
In-Reply-To: <20081126.004609.15230324.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0bd6.0f345e0a.167c.3b37@mx.google.com>
	 <20081126.004609.15230324.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Wed, Nov 26, 2008 at 9:46 AM, David Miller <davem@davemloft.net> wrote:
> From: eranian@googlemail.com
> Date: Wed, 26 Nov 2008 00:41:58 -0800 (PST)
>
>> +/*
>> + * system adminstrator configuration controls available via
>> + * the /sys/kerne/perfmon interface
>> + */
>
> This sysfs path typo I pointed out a few hours ago remains :-)
> It should be "/sys/kernel/perfmon", the 'l' is missing.
>
I will fix that. For now, I simply reposted to get the cc: list correct.
The script I use to mail the patches was unfortunately dropping
the cc-list.

Thanks.
