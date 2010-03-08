Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab0CHFhs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 00:37:48 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:48200 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0CHFhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 00:37:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=PmqG5csYDv/rEHz9BhixUegZk7rOggjLGIDD9PwWPNJ976ND6RbBm/lKiJ3VlmGTPa
         5Ym8Zn/wpHEmN6x8htcfXdgPi3+8dAuG4fXDcgZdExV/H7FyTOEdYoWPXfzWHEs9pvDn
         ryo+t5S1KCBV6a2fPP3bjdiSRI5PUcwHhVdEk=
MIME-Version: 1.0
In-Reply-To: <20100305212708.GC21773@elf.ucw.cz>
References: <20100305212708.GC21773@elf.ucw.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 8 Mar 2010 13:37:22 +0800
Message-ID: <f17812d71003072137u51be17a1ie3e50e30dea16f77@mail.gmail.com>
Subject: Re: bit errors on spitz
To: Pavel Machek <pavel@ucw.cz>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>, Dirk@opfer-online.de,
       arminlitzel@web.de, Cyril Hrubis <metan@ucw.cz>, thommycheck@gmail.com,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       dbaryshkov@gmail.com, omegamoon@gmail.com, utx@penguin.cz,
       zaurus-devel@www.linuxtogo.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 6, 2010 at 5:27 AM, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> I'm getting way too many bit errors on spitz, with various
> kernels.
>
> It may be tied to network usage (bluetooth or wifi?). It happens even
> on AC power.

Pavel,

What kind of bit errors? I'm not using any network here on my spitz so
not sure what exactly was happening. Could you paste the dmesg here
so we can help take a look?

- eric
