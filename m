Return-Path: <linux-kernel-owner+w=401wt.eu-S1758171AbZGRKxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171AbZGRKxs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 06:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbZGRKxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 06:53:46 -0400
Received: from mail-vw0-f177.google.com ([209.85.212.177]:56341 "EHLO
	mail-vw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758146AbZGRKxp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 06:53:45 -0400
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Jul 2009 06:53:44 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SAbckHySq03klzsjwPoCGBBEeReiVOKrVC07IbsH4kujqWMcktaPZSpgYpBzcGAmBx
         2FD8bcvTMF4FCK8NoFlcc0xO9nGj//bM40yNh0kxJDs7tXqjXOYdqfDlaogVWE9vk+ac
         JUdq0MhPWsk2pinGBUlhyEf3ZLERQZXijV5Qs=
MIME-Version: 1.0
Reply-To: crquan@gmail.com
In-Reply-To: <20090718072138.GA7711@merkur.ravnborg.org>
References: <1247386308-19628-1-git-send-email-crq@kernel.org>
	 <20090718072138.GA7711@merkur.ravnborg.org>
Date: Sat, 18 Jul 2009 18:47:35 +0800
X-Google-Sender-Auth: b904b795c05163d2
Message-ID: <91b13c310907180347s53d16f94of2a5070f9a130de@mail.gmail.com>
Subject: Re: [PATCH 0/6] kbuild configuration system improvements
From: Cheng Renquan <crq@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 3:21 PM, Sam Ravnborg<sam@ravnborg.org> wrote:
> I fixed them all up to:
> 1) include "kconfig:" prefix in subject
> 2) cc: of Roman Zippel which is kconfig maintainer
>
> There were a few checkpatch issues that I decided to ignore for now.
>
> Please always cc: Roman on kconfig patches as he is the mintainer.
>
> Applied to kbuild-next.git.
>
> Thanks,
>        Sam

Sorry, I just mixed up kbuild and kconfig, now I know it and will keep
that in mind in later developement, thank you,

--
Cheng Renquan, Shenzhen, China
