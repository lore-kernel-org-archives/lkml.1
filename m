Return-Path: <linux-kernel-owner+w=401wt.eu-S1764285AbXG0BHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764285AbXG0BHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 21:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756987AbXG0BHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 21:07:39 -0400
Received: from kai.krose.org ([140.186.190.96]:35916 "EHLO kai.krose.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752711AbXG0BHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 21:07:39 -0400
Message-ID: <46A94559.5080700@krose.org>
Date: Thu, 26 Jul 2007 21:07:37 -0400
From: Kyle Rose <krose@krose.org>
Organization: The Valley of Wind
User-Agent: Thunderbird 2.0.0.5 (X11/20070725)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Kyle Rose <krose@akamai.com>, linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
References: <46A8BAD4.8020004@akamai.com> <Pine.LNX.4.64.0707261826180.12711@fbirervta.pbzchgretzou.qr> <46A8CC41.306@krose.org> <Pine.LNX.4.64.0707261840480.12711@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0707261840480.12711@fbirervta.pbzchgretzou.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the pointer.  I've done this, and created an actual kernel
module tarball that is now available at
http://www.krose.org/~krose/projects/sk98lin/sk98lin.tar.gz.

Thanks,
Kyle


Jan Engelhardt wrote:
> On Jul 26 2007 12:30, Kyle Rose wrote:
>>> Sorry for the nitpick, it can be done easier :)
>> I'm sure it can.  I didn't want to have to figure out the kernel build
>> system just to get this one driver working.  Hence my desire for it to
>> remain in the kernel proper until sky2 utterly works. ;-)
> 
> Oh it's really easy, have a look at
> https://dev.computergmbh.de/svn/misc_kernel/oopser/trunk/Makefile
> 
> 
> 	Jan

