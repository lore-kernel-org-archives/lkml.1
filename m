Return-Path: <linux-kernel-owner+w=401wt.eu-S1753337AbYKZJk2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337AbYKZJk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 04:40:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYKZJkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 04:40:14 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:52615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbYKZJkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 04:40:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=mZ24GPm+Ch2Hfg2y1ucFvmeMHYT/xmmw7n2vKVjS8b8i4eSJn0bmei1GrNJJPGkm4y
         t4H7YXe3LCxfbbJVyDLf/Xl77tGw4gIgNPQYuiSV4cqNioXxq3y6PZoKCgmiUSZyIBEG
         0UMlOp/n8UkB9chjYltvQBZE3CGeog9deES/M=
Message-ID: <7c86c4470811260140x7e838c06v7236b196d0641786@mail.gmail.com>
Date: Wed, 26 Nov 2008 10:40:09 +0100
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

Fixed now.
Thanks

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
>
>
