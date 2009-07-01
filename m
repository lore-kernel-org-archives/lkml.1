Return-Path: <linux-kernel-owner+w=401wt.eu-S1754156AbZGAAUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156AbZGAAUE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbZGAATx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:19:53 -0400
Received: from [222.92.8.141] ([222.92.8.141]:43041 "EHLO lemote.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752496AbZGAATx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:19:53 -0400
Message-ID: <4A4AAB93.6040306@lemote.com>
Date: Wed, 01 Jul 2009 08:19:31 +0800
From: yanhua <yanh@lemote.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: wuzhangjin@gmail.com
CC: LKML <linux-kernel@vger.kernel.org>, linux-mips@linux-mips.org,
       Pavel Machek <pavel@ucw.cz>, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [BUG] MIPS: Hibernation in the latest linux-mips:master branch
 not work
References: <1246372868.19049.17.camel@falcon>
In-Reply-To: <1246372868.19049.17.camel@falcon>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Zhangjin Ð´µÀ:
> Hi,
>
> I just updated my git repository to the master branch of the latest
> linux-mips git repository, and tested the STD/Hibernation support on
> fuloong2e and yeeloong2f, it failed:
>
> when using the no_console_suspend kernel command line to debug, it
> stopped on:
>
> PM: Shringking memory... done (1000 pages freed)
> PM: Freed 160000 kbytes in 1.68 seconds (95.23 MB/s)
> PM: Creating hibernation image:
> PM: Need to copy 5053 pages
> PM: Hibernation image created (4195 pages copied)
>
> and then, the number indicator light of keyboard works well, but can not
> type anything. 
>
>   
Are there any other information about it? such as: it just freezes
there, or IDE irq lost messages after some time?

Is it duplicable every time?
> anybody have tested it on another platform? does it work?
>
> Regards,
> Wu Zhangjin
>
>
>
>   

