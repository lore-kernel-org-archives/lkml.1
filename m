Return-Path: <linux-kernel-owner+w=401wt.eu-S1756026AbYKCWys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbYKCWys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 17:54:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYKCWyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 17:54:38 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54859
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753663AbYKCWyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 17:54:37 -0500
Date: Mon, 03 Nov 2008 14:54:13 -0800 (PST)
Message-Id: <20081103.145413.38153968.davem@davemloft.net>
To: marcel@holtmann.org
Cc: jeff@garzik.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git patches] net driver fixes for 2.6.28-rc
From: David Miller <davem@davemloft.net>
In-Reply-To: <B9DCBB9E-9DE3-4114-9FFC-7A7C0C3DA920@holtmann.org>
References: <20081103205121.GA6005@havoc.gtf.org>
	<B9DCBB9E-9DE3-4114-9FFC-7A7C0C3DA920@holtmann.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 3 Nov 2008 23:07:58 +0100

> are you also queuing patches for drivers/net/usb/hso.c, because the
> current state of that driver is fully broken. It oopses and shows up
> with a WLAN RFKILL switch instead of WWAN. Also it has some weird
> disconnect race with the TTY layer. Some patches have been posted,
> but seems that nobody has picked them up so far.

The person submitting those patches is, frankly, creating a lot
of confusion.

He can't clone my tree or pull from it, then Greg KH tries to
take the fixes from him, and that doesn't go smoothly either.
