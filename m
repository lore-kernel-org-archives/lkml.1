Return-Path: <linux-kernel-owner+w=401wt.eu-S1762374AbYBSWXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762374AbYBSWXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 17:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757489AbYBSWX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 17:23:28 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47919
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755180AbYBSWX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 17:23:27 -0500
Date: Tue, 19 Feb 2008 14:24:01 -0800 (PST)
Message-Id: <20080219.142401.152827357.davem@davemloft.net>
To: andre@tomt.net
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB OOPS 2.6.25-rc2-git1
From: David Miller <davem@davemloft.net>
In-Reply-To: <47BAF36C.4000509@tomt.net>
References: <47BAF36C.4000509@tomt.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Tomt <andre@tomt.net>
Date: Tue, 19 Feb 2008 16:19:08 +0100

> Got this on a serial console today, using 2.6.25-rc2-git1. Machine was 
> not doing anything interesting at the time, but has its / and kernel on 
> a usb-storage device (usb pen drive).
> 
> Intel ICH8R chipset (and USB controller), running x86_64 kernel. I'll 
> post .config and some additional info when I get home later if it isn't 
> obvious what broke.

FWIW, I've seen a near identical crash on my Niagara system.

The only USB device attached is a CD/DVDW drive sitting behind
usb-storage.
