Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbXDMDbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbXDMDbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 23:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbXDMDbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 23:31:17 -0400
Received: from lixom.net ([66.141.50.11]:59546 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXDMDbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 23:31:17 -0400
Date: Thu, 12 Apr 2007 22:48:50 -0500
To: Steve Wise <swise@opengridcomputing.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: xmon debugger doc?
Message-ID: <20070413034850.GA12654@lixom.net>
References: <1176410647.27519.6.camel@stevo-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176410647.27519.6.camel@stevo-desktop>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: olof@lixom.net (Olof Johansson)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:44:07PM -0500, Steve Wise wrote:
> Can someone please point me at ppc64 xmon debugger usage /
> documentation? I've had little luck finding info on-line.

The help output from it is pretty much all there is.

You might have better luck asking on linuxppc-dev@ozlabs.org though
(adding as Cc).

There's also an old writeup at
http://mbligh.org/linuxdocs/Kernel/DebuggingPPC64 for the very basics
of digging through a crash. Some of it is likely out of date by now.


-Olof
