Return-Path: <linux-kernel-owner+w=401wt.eu-S965373AbXDBKVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373AbXDBKVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965378AbXDBKVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:21:46 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:53302 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965373AbXDBKVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:21:45 -0400
Message-ID: <4610D937.20002@nagafix.co.uk>
Date: Mon, 02 Apr 2007 11:21:43 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 1.5.0.10 (X11/20070304)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Blaisorblade <blaisorblade@yahoo.it>, devzero@web.de,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel
 release ?
References: <1712880100@web.de> <200704012108.14597.blaisorblade@yahoo.it> <46100EF5.7040802@nagafix.co.uk> <20070402020530.GA589@c2.user-mode-linux.org>
In-Reply-To: <20070402020530.GA589@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Sun, Apr 01, 2007 at 08:58:45PM +0100, Antoine Martin wrote:
>> I reckon that one critical thing which could drastically increase the 
>> user base would be to have a working virtual framebuffer implementation.
> 
> Why?  I've never understood what a framebuffer gives you that you
> don't have now.
Just like the network auto-configuration via dhcp, it would allow users 
to download images+kernel and run them like appliances without 
understanding anything about X or UML, just click and run.
We are all capable of setting up Xvfb here, but most users are not, 
which is why they download ready-made images.
It would also make it a lot easier to focus on writing a management UI, 
hell if there isn't one shortly after, I'll do one myself!
Think of a UML browser image (running IE via wine in a limited image 
with just X + wine + IE - I would much prefer that to having wine+IE 
installed locally), testing framebuffer apps like gtk-fb/cairo-fb 
without risking your dev environment, etc...

Antoine
