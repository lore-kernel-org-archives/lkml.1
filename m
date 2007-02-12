Return-Path: <linux-kernel-owner+w=401wt.eu-S1750946AbXBLANM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750946AbXBLANM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750950AbXBLANM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:13:12 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43104 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750946AbXBLANK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:13:10 -0500
Date: Mon, 12 Feb 2007 00:26:52 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
Message-ID: <20070212002652.1ea4026e@localhost.localdomain>
In-Reply-To: <20070211233822.GD13913@1wt.eu>
References: <fa.FzHdYYYH5Ru57c8/yRxLylpH0Kk@ifi.uio.no>
	<fa.DhkemAgVI60diqZy0t9GzpwyLmk@ifi.uio.no>
	<fa.E/NjHlgg0HqDg5CgZjnCHFi2AMM@ifi.uio.no>
	<fa.kop49l/7yexJoUGrzk6vVeIP934@ifi.uio.no>
	<fa.EgQN5JpU6xrZSLyOY0kWjJ26hUM@ifi.uio.no>
	<45CF60F2.5020308@shaw.ca>
	<20070211215211.GB13913@1wt.eu>
	<1171232786.4493.62.camel@nigel.suspend2.net>
	<20070211224637.GC13913@1wt.eu>
	<1171235922.4493.114.camel@nigel.suspend2.net>
	<20070211233822.GD13913@1wt.eu>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Unless I'm mistaken, I have to type the passphrase twice then :
>   - once at suspend
>   - once at resume
> 
> which is once more per "boot" than what I'm doing on loop-aes.

You don't need to type in a key at suspend time if you don't want to.
Think about gpg email - I can send you an encrypted email without typing
any keys, you need the right key however to read it.

Alan
