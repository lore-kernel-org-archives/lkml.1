Return-Path: <linux-kernel-owner+w=401wt.eu-S1422652AbXCBAbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422652AbXCBAbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 19:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422653AbXCBAbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 19:31:49 -0500
Received: from gw.goop.org ([64.81.55.164]:34329 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422652AbXCBAbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 19:31:49 -0500
Message-ID: <45E77073.1000208@goop.org>
Date: Thu, 01 Mar 2007 16:31:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: License violation?
References: <45E76C16.1030706@gmail.com>
In-Reply-To: <45E76C16.1030706@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> Hi.
>
> I have a GPL driver (written by me) with workarounds, since I hadn't
> know-how, when I wrote it. Now I've got 2.4 proprietary driver from
> the vendor. Is use of the 2.4 driver know-how OK? (And could be such
> driver merged?)
>
> These are lines from the proprietary driver:
>        IMPORTANT SAFETY & LEGAL INFORMATION:
>
>         This source file is provided as part of the SensAble
>         Technologies PDD/GHOST Software Development Toolkit in
>         order to facilitate the use of PCI-based PHANToM haptic
>         interface devices across various Linux kernel revisions.
>         It is meant to be recompiled without modification.  It
>         should NOT be modified in any way. Any modification of
>         this source code will void any and all software and/or
>         hardware warranties and maintenance agreements with
>         SensAble Technologies or its assignees.  Furthermore,
>         modification of this source file may result in the damage
>         or failure of the user's hardware.  SensAble Technologies
>         and its assignees assume no responsibility for any damage
>         or injury resulting from the modification of this file.
>
> It's obvious, that if somebody was using the GPL driver, he'll lost
> warranty et al. (But this is not the question.) 

Seems reasonable to me.   This isn't license text.  They're not saying
you can't modify it; they're just saying you own the pieces if you
modify it and break it.  Is there an actual license?

    J
