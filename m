Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab0CCPKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 10:10:21 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:46291 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab0CCPKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 10:10:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=WWfmN8D11jvaOHgCnZP4CICRCxP47TnulH5iBRY96VwzKGyat4nLtN45ucovPGeU8O
         mNWRPknfUVIqZjCdHjfHRamPp5GBNLRAZT2FBm+pS7d2ISWKmu1XySyB+dwGjhb5iTiA
         4aj8kI07I/wuyXuq5Bl8PSBhDtr78vfu0Mvbw=
MIME-Version: 1.0
In-Reply-To: <20100303.010746.134683403.davem@davemloft.net>
References: <20100303082241.GA32640@bicker>
	 <20100303.010746.134683403.davem@davemloft.net>
Date: Wed, 3 Mar 2010 20:40:18 +0530
Message-ID: <3f9a31f41003030710p4209fa1dq37d14a67b12657d@mail.gmail.com>
Subject: Re: [patch] cassini: fix off by one
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: error27@gmail.com, netdev@vger.kernel.org, adobriyan@gmail.com,
       akpm@linux-foundation.org, yanghy@cn.fujitsu.com, kaber@trash.net,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dave and Dan,

On Wed, Mar 3, 2010 at 2:37 PM, David Miller <davem@davemloft.net> wrote:
> From: Dan Carpenter <error27@gmail.com>
> Date: Wed, 3 Mar 2010 11:22:41 +0300
>
>> There are only 6 link_modes.
>>
>> Signed-off-by: Dan Carpenter <error27@gmail.com>
>
> Applied.

I am curious should we add these kind of email address in git log.
error27 seems error to me ;-)

Can we make Signed-off address little bit more sensible.

Thanks,
--
Jaswinder
