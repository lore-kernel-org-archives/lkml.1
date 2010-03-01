Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab0CAVvn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 16:51:43 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:65045 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0CAVvm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 16:51:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qS+WResMbEyCSx5P9mW4OoIbOowi3BEk29f3mr1avqGduPsCKehAsbsFNbLYyFVwNv
         sC3xIMbrJno+6G3JDjtKJK3bQpw6QEebTnnMFWvgBshPWM0Vq49I7FbaShLrBc7cd1cr
         tlWOiBRTy5zD6F7VOSw8JmAJSmkjHip/0Tx68=
MIME-Version: 1.0
In-Reply-To: <20100301132501.GF4219@axis.com>
References: <20100301132501.GF4219@axis.com>
Date: Mon, 1 Mar 2010 13:51:41 -0800
X-Google-Sender-Auth: 0384da9c815ce7c8
Message-ID: <1f1b08da1003011351j20c35039hfe57976d99f7f501@mail.gmail.com>
Subject: Re: [GIT PULL] CRIS updates for 2.6.34
From: john stultz <johnstul@us.ibm.com>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-cris-kernel <linux-cris-kernel@axis.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 5:25 AM, Jesper Nilsson <jesper.nilsson@axis.com> wrote:
> Please pull the below repo for some minor CRIS-fixes.
>
> Thanks!
>
> The following changes since commit 1836d95928a0f41ada0cbb2a6c4e46b027db9491:
>  Linus Torvalds (1):
>        Merge branch 'for-linus' of git://git.kernel.org/.../ericvh/v9fs
>
> are available in the git repository at:
>
>  git://repo.or.cz/cris-mirror.git for-linus
>
> Roel Kluin (1):
>      CRIS v32: Should index be positive?
>
> Thomas Gleixner (1):
>      cris: Fixup last users of irq_chip->typename

Hey Jesper,
   Is there a reason that my "Convert cris to arch_gettimeoffset"
patch keeps getting ignored?  Its fairly trivial, and its been sitting
around in -mm since July of last year.  Andrew sent it to you back in
September.

It would be really great to get it included this cycle. Its holding
back cleanups to the timekeeping core.

I'll be resending the patch later today if you can't find it.

thanks
-john
