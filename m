Return-Path: <linux-kernel-owner+w=401wt.eu-S1753952AbZDUI5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952AbZDUI5k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755221AbZDUI5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:57:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49726
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755181AbZDUI5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:57:16 -0400
Date: Tue, 21 Apr 2009 01:57:08 -0700 (PDT)
Message-Id: <20090421.015708.65867910.davem@davemloft.net>
To: peter@holik.at
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/2] usb driver for intellon int51x1 based PLC like
 devolo dlan duo
From: David Miller <davem@davemloft.net>
In-Reply-To: <5c52681c17a9cd66ec59e9d9cad3ee46.squirrel@webmail.it-technology.at>
References: <0681089db5bdc5acc805ed52130dc9a5.squirrel@webmail.it-technology.at>
	<Pine.LNX.4.64.0904181834210.3691@wrl-59.cs.helsinki.fi>
	<5c52681c17a9cd66ec59e9d9cad3ee46.squirrel@webmail.it-technology.at>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Peter Holik" <peter@holik.at>
Date: Sat, 18 Apr 2009 18:42:59 +0200 (CEST)

> I am submitting a series of 2 patches for inclusion in 2.6.30.
> Here is a brief description of the patch series:
> - because of using the same function get_ethernet_addr as cdc_ether.c
>   i export usbnet_get_ethernet_addr from usbnet and fixed cdc_ether
>   (suggested by Oliver Neukum).
> - usb driver for intellon int51x1 based PLC like devolo dlan duo
>   with improvements suggested by the guys of the mailinglist

I've applied the most recent version of this driver submission
to net-next-2.6, thanks!
