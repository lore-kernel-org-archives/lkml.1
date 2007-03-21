Return-Path: <linux-kernel-owner+w=401wt.eu-S964865AbXCUUsr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964865AbXCUUsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 16:48:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933855AbXCUUsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 16:48:47 -0400
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:59594 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932932AbXCUUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 16:48:47 -0400
Message-ID: <46019A1F.7060708@lwfinger.net>
Date: Wed, 21 Mar 2007 15:48:31 -0500
From: Larry Finger <larry.finger@lwfinger.net>
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: 2.6.21-rc4-mm1
References: <20070319205623.299d0378.akpm@linux-foundation.org> <1174433034.62033.16.camel@localhost> <20070320223643.d8cbc3f6.akpm@linux-foundation.org> <4601761F.4000302@lwfinger.net> <20070321185900.GC3801@tuxdriver.com> <20070321202225.GN10459@waste.org>
In-Reply-To: <20070321202225.GN10459@waste.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> With the latest -mm, I'm now getting this:
> 
> Mar 21 15:06:52 cinder kernel: ipw2200: Detected Intel PRO/Wireless
> 2200BG Network Connection
> Mar 21 15:06:52 cinder kernel: firmware_loading_store: unexpected
> value (0)
> Mar 21 15:06:52 cinder kernel: ipw2200: ipw2200-bss.fw
> request_firmware failed:
> Reason -2
> Mar 21 15:06:52 cinder kernel: ipw2200: Unable to load firmware: -2
> Mar 21 15:06:52 cinder kernel: ipw2200: failed to register network
> device
> 

I am seeing similar messages trying to load bcm43xx firmware with 2.6.21-rc4-mm1.

Larry

