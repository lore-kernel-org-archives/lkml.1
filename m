Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab0COGKM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 02:10:12 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:41649 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680Ab0COGKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 02:10:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y/uHl+5jjgXN+SAT0UWU6YU7eumBUBcvg7UwnQCsOry/Fhhpopjaw0WzhvA+PBgV4m
         24Di9G6tW8eqsCot3wDegxNeVJ9WFzHuYJ9D0KKTN99+9ia3IdUZJ81YkWwzCbSAlhtk
         mBAvvJxy7tbcZfpS9yUHmu1wUlfRpgPCMW7JA=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003142155470.19244@sony>
References: <alpine.LFD.2.00.1003142155470.19244@sony>
Date: Mon, 15 Mar 2010 07:10:06 +0100
Message-ID: <b170af451003142310i3fe61282pb6536f6d2000c9c8@mail.gmail.com>
Subject: Re: ACPI patches for Linux-2.6.34-rc1
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/15 Len Brown <lenb@kernel.org>:
> Hi Linus,
>
> please pull from:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git release
>
> Here is why three things included in this request
> look somewhat "merge-windo-ish".

Len, you seem to hardly ignore
[PATCH] ACPI / PM: Move ACPI video resume to a PM notifier

AFAIK this didn't hit rc1, is not included in this patchset and we
couldn't get any response from you in this thread.

-- 
Rafał
