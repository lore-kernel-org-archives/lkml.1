Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab0BYP5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:57:39 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:37556 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab0BYP5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:57:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=MvS3l6aaEY0yV+nUZsc2hxjqXL6XL5sP8CShmZfPyy/4iNX9goYSbThi11TaUItDNn
         lIVWJ8UaOyxGo42D6VDDMJDFnPxP8dQ+UTBoAGX0XaGrDP4Z5cKabs8KuRU5Y2E7mlNl
         2VJJRFiADWtVbYkGKwiIkvQtHcNZi2rVViZFM=
MIME-Version: 1.0
In-Reply-To: <20100225153853.GA2659@darkstar>
References: <20100225153853.GA2659@darkstar>
Date: Thu, 25 Feb 2010 23:57:36 +0800
Message-ID: <a8e1da1002250757o2de49b7axd370cc13b1fea398@mail.gmail.com>
Subject: Re: kernel.h cleanup patchset update for -mm
From: Dave Young <hidave.darkstar@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 25, 2010 at 11:38 PM, Dave Young <hidave.darkstar@gmail.com> wrote:
> Hi, andrew
>
> here is an update version of kernel.h cleanup patchset
>
> changes from first version:
> 1. bisectable fix
> 2. style fix
> 3. make panic/string/printk cleanup standalone patch
> 4. trace stuff is put into linux/trace.h and include it in kernel.h
> 5. _HEXDUMP_H change to _LINUX_HEXDUMP_H [Mike Frysinger]
>
> Please drop the following patch in mm tree:
> kernelh-printk-panic-string-cleanup.patch
> kernelh-intr_sqrt-cleanup.patch
>
> use this series instead in "01/02/03/04/05/06/07" order.

don't know why, some of them sending failed, maybe too many recipients,
so I remove some people from address list and resend the failed patches,
sorry for that.

>
> Thanks.
>
> --
> Regards
> dave
>



-- 
Regards
dave
