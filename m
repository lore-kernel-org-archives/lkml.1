Return-Path: <linux-kernel-owner+w=401wt.eu-S1752613Ab0AROA5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752613Ab0AROA5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 09:00:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397Ab0AROAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 09:00:54 -0500
Received: from dan.rpsys.net ([93.97.175.187]:60093 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752297Ab0AROAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 09:00:52 -0500
Subject: Re: [PATCH] led-class.c: quiet boot messages
From: Richard Purdie <rpurdie@rpsys.net>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <201001061534.55707.hartleys@visionengravers.com>
References: <201001061534.55707.hartleys@visionengravers.com>
Content-Type: text/plain
Date: Mon, 18 Jan 2010 14:01:05 +0000
Message-Id: <1263823265.26227.104.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-06 at 15:34 -0700, H Hartley Sweeten wrote:
> led-class.c: quiet boot messages
> 
> As each led device gets registered a kernel message gets printed. In
> an embedded system with a number of leds this can produce a lot
> of output that just looks like noise.
> 
> Change the message type to KERN_DEBUG since it might be useful
> in the dmesg output "after" booting.

Queued in the LED tree, thanks.

Richard

-- 
Richard Purdie
Intel Open Source Technology Centre

