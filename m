Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab0BBIzk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 03:55:40 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:54185 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0BBIzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 03:55:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XNh/9w89hytFDbhwddY28/7sgH4AuBWZReX52RpofP4qslgc+xaYC5px778AvpJkZA
         cGzRJgu5rkRxeYecJBvXX/VQ3fpxMA8a+kOqxEw1NOcCTzBj79dUtvgcYhAQJBKW3kFv
         nkc+0UKInN1N4GwfTSnMTXnvQMA2CFQb/B36U=
MIME-Version: 1.0
In-Reply-To: <20100201185506.GA11045@lst.de>
References: <20100201185506.GA11045@lst.de>
Date: Tue, 2 Feb 2010 16:55:36 +0800
Message-ID: <a8e1da1002020055ua39ceceqeac9559961e256f5@mail.gmail.com>
Subject: Re: [PATCH 1/6] generic sys_old_select
From: Dave Young <hidave.darkstar@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux@arm.linux.org.uk, dhowells@redhat.com,
       ysato@users.sourceforge.jp, tony.luck@intel.com, geert@linux-m68k.org,
       zippel@linux-m68k.org, gerg@uclinux.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, jdike@addtoit.com, tglx@linutronix.de,
       mingo@redhat.com, hpa@zytor.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/01/2010 10:55 AM, Christoph Hellwig wrote:
[snip]
> +asmlinkage long sys_old_select(struct sel_arg_struct __user * arg);

A trival style problem: "foo * bar"

--
Regards
dave
