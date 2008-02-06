Return-Path: <linux-kernel-owner+w=401wt.eu-S1762975AbYBFMUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762975AbYBFMUj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 07:20:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762052AbYBFMUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 07:20:32 -0500
Received: from smtp2.sssup.it ([193.205.80.100]:52428 "EHLO smpt.sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761744AbYBFMUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 07:20:31 -0500
Message-ID: <47A9A5B5.3060800@gandalf.sssup.it>
Date: Wed, 06 Feb 2008 13:19:01 +0100
From: michael <trimarchi@gandalf.sssup.it>
User-Agent: Thunderbird 1.5.0.14pre (X11/20071023)
MIME-Version: 1.0
To: Remy Bohmer <linux@bohmer.net>
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>, fabio@gandalf.sssup.it,
       Andrew Victor <linux@maxim.org.za>, Chip Coldwell <coldwell@redhat.com>,
       Marc Pignat <marc.pignat@hevs.ch>, David Brownell <david-b@pacbell.net>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
References: <20080129224316.GA23155@gandalf.sssup.it>	 <20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>	 <47A051A7.7030004@gandalf.sssup.it>	 <20080130133659.55ebd828@dhcp-252-066.norway.atmel.com>	 <47A09723.7020000@gandalf.sssup.it>	 <20080130164631.7de4f6bd@dhcp-252-066.norway.atmel.com>	 <47A12A2E.5040309@gandalf.sssup.it>	 <20080131160721.6dddf30e@dhcp-252-066.norway.atmel.com>	 <3efb10970801311136y12670f12x6e4fdd44de3677b9@mail.gmail.com>	 <20080204133925.73733f5f@dhcp-252-066.norway.atmel.com> <3efb10970802041144j6b4e6893j293819238b5b82e8@mail.gmail.com>
In-Reply-To: <3efb10970802041144j6b4e6893j293819238b5b82e8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the serial driver works fine. The problem seems to be related to the 
tclib, when I use
it as a clocksource. The numbers of overruns depends on the type of 
files too.
It is possible?

Regards
Michael


