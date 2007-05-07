Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbXEGKYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbXEGKYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 06:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754289AbXEGKYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 06:24:48 -0400
Received: from khc.piap.pl ([195.187.100.11]:59301 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287AbXEGKYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 06:24:47 -0400
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Cc: netdev@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <rmk@arm.linux.org.uk>, Jeff Garzik <jeff@garzik.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] ARM: include IXP4xx "fuses" support
References: <m3abwhcy74.fsf@maximus.localdomain>
	<m3wszlbiom.fsf@maximus.localdomain>
	<f19298770705062224v5f60535bn7dfce17f4a5e04f@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Mon, 07 May 2007 12:24:46 +0200
In-Reply-To: <f19298770705062224v5f60535bn7dfce17f4a5e04f@mail.gmail.com> (Alexey Zaytsev's message of "Mon, 7 May 2007 09:24:48 +0400")
Message-ID: <m3k5vlc4nl.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

"Alexey Zaytsev" <alexey.zaytsev@gmail.com> writes:

> #ifndef __ASSEMBLY__
>
>> +static inline u32 ixp4xx_read_fuses(void)

Oops. You're right, of course.
-- 
Krzysztof Halasa
