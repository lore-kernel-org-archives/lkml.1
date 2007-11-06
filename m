Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbXKFO4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbXKFO4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 09:56:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbXKFO4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 09:56:43 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:55210 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752398AbXKFO4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 09:56:42 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Nov 2007 09:56:42 EST
Date: Tue, 06 Nov 2007 15:26:37 +0100
From: Arnd Hannemann <arnd@arndnet.de>
Subject: Re: Truecrypt in kernel ?
In-reply-to: <2ed59cbb0711051742k5e4a7858ie95126399006ba53@mail.gmail.com>
To: Zurk Tech <zurktech@gmail.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <4730799D.5020800@arndnet.de>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
X-IronPort-AV: E=Sophos;i="4.21,378,1188770400";   d="scan'208";a="20244527"
X-Enigmail-Version: 0.95.0
References: <2ed59cbb0711051742k5e4a7858ie95126399006ba53@mail.gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Zurk Tech schrieb:
> i was trying to move my truecrypt container from my xp box to my
> debian etch box.
> on windows xp its just double click to mount it, no need to even
> install with the portable option.
> on linux i had to download the source of the kernel, compile it, add
> the truecrypt module, reboot and then mount it.
> just wondering why the truecrypt module isnt in the mainline kernel ?
> its the only cross platform encrypted disk solution out there and it
> should be less of a chore to use it in linux...is there something
> wrong with the truecrypt kernel driver ?

Its not the only cross platform solution: You could use LUKS[1] on linux
and FreeOTFE[2] on win platform. With modern linux distributions LUKS is
very easy to use.

[1] http://luks.endorphin.org
[2] http://www.freeotfe.org

Best regards, Arnd
