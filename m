Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbYANT0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbYANT0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 14:26:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbYANT0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 14:26:32 -0500
Received: from mail.windriver.com ([147.11.1.11]:60228 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbYANT0b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 14:26:31 -0500
Message-ID: <478BB74E.6020506@windriver.com>
Date: Mon, 14 Jan 2008 13:26:06 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: State of kgdb on x86-64
References: <478BB35B.9060507@siemens.com>
In-Reply-To: <478BB35B.9060507@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 14 Jan 2008 19:26:06.0369 (UTC) FILETIME=[4F0A2910:01C856E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was working at the point that I tested it with the 2.6.24-rc5 on
x86_64.  However I suspect my kernel config may differ drastically from
what you are using.

Without any other context provided than the generic message, it is hard
to know what might have happened. 

Jason.

Jan Kiszka wrote:
> Hi Jason,
>
> what is the state of the kgbd git repos? What should work, what might be
> broken?
>
> I'm asking as today I tried to get kgdb up and running on a 4-way x86-64
> Xeon box with both 2.6.24-rc6 and -rc7. Once kgdb is enabled in .config,
> the boot stops early with this panic:
>
> Kernel panic - not syncing: Attempted to kill init!
>
> May I have more success with 2.6.23? Was x86-64 tested and found working
> once? I can dig deeper into the above issue, but before starting
> blindly, I would like to asses if there could be more issues ahead on
> this arch.
>
> Thanks,
> Jan
>
>   

