Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbXHBKna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbXHBKna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 06:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbXHBKnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 06:43:23 -0400
Received: from wildsau.enemy.org ([193.170.194.34]:33092 "EHLO
	wildsau.enemy.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980AbXHBKnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 06:43:22 -0400
From: Herbert Rosmanith <kernel@wildsau.enemy.org>
Message-Id: <200708021042.l72AguIM008585@wildsau.enemy.org>
Subject: Re: VIA EPIA EK: strange eth dev numbering
In-Reply-To: <46B1B160.8090906@msgid.tls.msk.ru>
To: Michael Tokarev <mjt@tls.msk.ru>
Date: Thu, 2 Aug 2007 12:42:56 +0200 (MET DST)
CC: linux-kernel@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL100 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Strange or not, correct or not - depends on the point of view.
> 
> The key word here is "udev" - check your udev rules.  Since some time
> ago udev on some distros comes with rules to give persistent device
> names for network interfaces.  Some time ago you had eth0 and eth1
> with different hardware, and udev remembered this fact somewhere.
> Now it sees new hardware, and gives it consecutive numbers, renaming
> kernel devices.

hu. where are the days when eth0 was eth0 ...

this means that, when I exchange a network card and replace it with a
new one, it will cost an "ethX" device name each time.

FYI, distribution is latest Gentoo.

as a friend of mine puts it:

    "Haha das is geil, das is wie bei Windows"
    "Wo er merkt, dass du ein neues Mainboard hast :)"

which translates:

    "Haha, that's randy, that's like in Windows, which
    notices that you've got a new mainboard"

Bad, bad Ferdl! How dare you compare this to M$Windows ;-)

well, Michael, thanks for the help,
herp

