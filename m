Return-Path: <linux-kernel-owner+w=401wt.eu-S1751336AbZHXC7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751336AbZHXC7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 22:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751116AbZHXC7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 22:59:20 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:48726 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZHXC7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 22:59:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qWSxM8UTYMLUOPQU2n5hG436+XN/34Efwf3/pBRARQPzGVC/7GcPX8/fOXtmSUXFg/
         OCYU10gwGNOYGinmsbG07fLnMJmT2FWp5jnk9PK8htjTcDWIe6R5r8iA0EQiZVj7labl
         yWlywbeZKs1+ShcN9NAwb92Ase9Pk1Q4fwXJ0=
MIME-Version: 1.0
In-Reply-To: <a8e1da0908172025s728c62ber37acb6c2073f7794@mail.gmail.com>
References: <a8e1da0908172025s728c62ber37acb6c2073f7794@mail.gmail.com>
Date: Mon, 24 Aug 2009 10:59:20 +0800
Message-ID: <a8e1da0908231959v5d82b2e9h7e294d25684b3a9e@mail.gmail.com>
Subject: Re: -mm hang while shutdown with printk_delay
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 11:25 AM, Dave Young<hidave.darkstar@gmail.com> wrote:
> Hi,
>
> Test with printk_delay=200,
>
> /sbin/halt -p
>
> kernel hang after following message:
>
> Disabling non-boot CPUs
>
> There's no such problem with 2.6.31-rc6

Status update:

I have no such problem with mmotm 2009-08-20-19-18

-- 
Regards
dave
