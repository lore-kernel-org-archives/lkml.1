Return-Path: <linux-kernel-owner+w=401wt.eu-S1752653AbXDHGrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653AbXDHGrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 02:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbXDHGrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 02:47:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53679
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752653AbXDHGrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 02:47:10 -0400
Date: Sat, 07 Apr 2007 23:47:08 -0700 (PDT)
Message-Id: <20070407.234708.93384523.davem@davemloft.net>
To: poemann@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at net/core/skbuff.c in linux-2.6.21-rc6
From: David Miller <davem@davemloft.net>
In-Reply-To: <19061b0b0704071111m65c70d1ei736de86ad2f09a82@mail.gmail.com>
References: <19061b0b0704071111m65c70d1ei736de86ad2f09a82@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartek <poemann@gmail.com>
Date: Sat, 7 Apr 2007 20:11:13 +0200

> I have problem with a Linux kernel oops. It mostly appears when I
> download files using bittorrent or other large file. I have a phone
> modem based Internet access using Home Internet Solution
> (http://en.wikipedia.org/wiki/Home_internet_Solution). I use Debian
> testing, Linux vanilla version: 2.6.21-rc6 (however I noticed that
> problem since Linux ver. 2.6.15, doesn't matter if that was vanilla
> kernel or from Debian distro), Here my sys info:

Please reproduce and provide a new crash dump without the nvidia
binary-only module loaded.

Thank you.
