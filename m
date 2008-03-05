Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbYCEN52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbYCEN52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYCEN5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:57:17 -0500
Received: from orion2.pixelized.ch ([195.190.190.13]:57363 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbYCEN5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:57:16 -0500
Message-ID: <47CEA6B1.3080803@cateee.net>
Date: Wed, 05 Mar 2008 14:57:05 +0100
From: "Giacomo A. Catenazzi" <cate@cateee.net>
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Alexey Zaytsev <alexey.zaytsev@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: Google's Summer of Code?
References: <84144f020803041045i70bbb05l6983bd14c5bcc91a@mail.gmail.com>	<alpine.LFD.1.00.0803041127290.12253@woody.linux-foundation.org>	<84144f020803041155k222c13ecu13c8c9534ced87e5@mail.gmail.com>	<f19298770803041205i21a0c6d2mdf712b52cb00cfd5@mail.gmail.com> <20080304152303.2a041814@cuia.boston.redhat.com>
In-Reply-To: <20080304152303.2a041814@cuia.boston.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Tue, 4 Mar 2008 23:05:34 +0300
> "Alexey Zaytsev" <alexey.zaytsev@gmail.com> wrote:
>> Maybe the Kernelnewbies should stand up as the mentoring organisation?
> 
> Kernelnewbies is just a community of people, without much organization.
> 
> However, I would be happy to coordinate a group of mentors for Linux
> kernel Summer of Code as well as be a mentor for the kernel subsystems
> that I know something about.
> 
> If we can find mentors to cover most of the kernel (volunteers? anyone?),
> we can do a good enough job of mentoring the students that we could sign
> up for Summer of Code.
> 
> Summer of Code could also be a good way to get some kernel related work
> done, for example LTP tests for kernel subsystems that do not have a
> test suite yet.  Maybe not the most interesting work, but it can be very
> educational as well as useful - that and $5000 may be enough to motivate
> students to get some of this "boring work" done :)

I propose and I could mentor two projects about automagical kernel
configuration:

- add support to menuconfig, to show what you should enable (not
really an automagical configuration, but more an helper which
know better(?) your hardware).
- new ideas about hardware/protocol detection and detection heuristics.

I've already done some parts: generating an hardware->kernel driver
database ( http://cateee.net/lkddb/ ), and a working prototype of
autoconfiguration ( http://testing.cateee.net/autokernconf/ ).

I really want to have new ideas and other developers. I think the
idea are appealing to students, and it doesn't requires a lot of
knowledge of kernel internal.

ciao
	cate
