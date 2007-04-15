Return-Path: <linux-kernel-owner+w=401wt.eu-S1752540AbXDOJKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbXDOJKt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 05:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbXDOJKs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 05:10:48 -0400
Received: from smtp1-g19.free.fr ([212.27.42.27]:35510 "EHLO smtp1-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752540AbXDOJKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 05:10:48 -0400
From: Duncan Sands <duncan.sands@math.u-psud.fr>
To: Simon Arlott <simon@fire.lp0.eu>
Subject: Re: [PATCH] usbatm: Detect usb device shutdown and ignore failed urbs.
Date: Sun, 15 Apr 2007 11:11:54 +0200
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <46216F5F.7070009@simon.arlott.org.uk>
In-Reply-To: <46216F5F.7070009@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704151111.54776.duncan.sands@math.u-psud.fr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 15 April 2007 02:18:39 Simon Arlott wrote:
> Detect usb device shutdown and ignore failed urbs.
> This happens when the driver is unloaded or the device is unplugged.
> 
> Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
> Cc: Duncan Sands <duncan.sands@math.u-psud.fr>

Acked-by: Duncan Sands <baldrick@free.fr>
