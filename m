Return-Path: <linux-kernel-owner+w=401wt.eu-S1758163AbYHZRPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163AbYHZRPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYHZRO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:14:57 -0400
Received: from smtp4.tech.numericable.fr ([82.216.111.40]:41859 "EHLO
	smtp4.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYHZRO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:14:56 -0400
Message-ID: <48B43A0A.5060406@numericable.fr>
Date: Tue, 26 Aug 2008 19:14:50 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird/3.0a2 (X11; 2008082610)
MIME-Version: 1.0
To: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [2.6.27-rc4-git5] ipv4: sysctl fixes causes "cannot open /proc/sys/net/ipv4/route/flush"
References: <48B43562.20602@numericable.fr>
In-Reply-To: <48B43562.20602@numericable.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rufus & Azrael wrote:
> Hi Al and David,
>
>
> After building the fresh 2.6.27-rc4-git5 kernel with your patch in 
> commit 2f4520d35d89ca6c5cd129c38e3b11f0283b7d1b, I have this error on 
> boot :
>
>> Cannot open "/proc/sys/net/ipv4/route/flush"
> but networking works fine.
>
> Do I modify something in my sysctl.conf file ? (see attached).
>
> Thanks for your explanations,
>
> Regards.
>
>
>
Ok, perhaps is it a regression of your previous patches in commits 
eeb61f719c00c626115852bbc91189dc3011a844 and 
6f9f489a4eeaa3c8a8618e078a5270d2c4872b67 (
net: missing bits of net-namespace / sysctl)

Regards.
