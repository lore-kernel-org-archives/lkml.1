Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbXIWQX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbXIWQX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2007 12:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbXIWQXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Sep 2007 12:23:23 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:57671 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563AbXIWQXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2007 12:23:22 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH 2/3] cxacru: Reduce initialisation delay
Date: Sun, 23 Sep 2007 18:23:22 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <46F68708.6070409@simon.arlott.org.uk> <46F6879A.8040408@simon.arlott.org.uk>
In-Reply-To: <46F6879A.8040408@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709231823.22957.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

> +	usb_info(usbatm, "started firmware\n");
...
> +		usb_info(usbatm, "loaded config data\n");

maybe these should be debug messages.  When are they useful?

Ciao,

Duncan.
