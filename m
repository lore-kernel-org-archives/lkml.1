Return-Path: <linux-kernel-owner+w=401wt.eu-S932516AbXDBPnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbXDBPnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 11:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXDBPnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 11:43:40 -0400
Received: from mail.nagafix.co.uk ([194.145.196.85]:46672 "EHLO
	mail.nagafix.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932516AbXDBPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 11:43:39 -0400
Message-ID: <461124A9.7080609@nagafix.co.uk>
Date: Mon, 02 Apr 2007 16:43:37 +0100
From: Antoine Martin <antoine@nagafix.co.uk>
User-Agent: Thunderbird 1.5.0.10 (X11/20070304)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
       Blaisorblade <blaisorblade@yahoo.it>, devzero@web.de,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [uml-devel] [RFC] UML kernel & rootfs bundle with every kernel
 release ?
References: <1712880100@web.de> <200704012108.14597.blaisorblade@yahoo.it> <46100EF5.7040802@nagafix.co.uk> <20070402020530.GA589@c2.user-mode-linux.org> <4610D937.20002@nagafix.co.uk> <Pine.LNX.4.64.0704021318410.1276@anakin> <20070402145300.GA6179@c2.user-mode-linux.org>
In-Reply-To: <20070402145300.GA6179@c2.user-mode-linux.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Mon, Apr 02, 2007 at 01:22:00PM +0200, Geert Uytterhoeven wrote:
>> There are patches floating around for a UML frame buffer device.
>> Gerd Kraxel^H^H^H^H^H^HHoffmann did one using plain X11, which worked
>> great when I gave it a try.
>>
>> I suggest taking a look at Gerd's patches. IIRC, he posted them to lkml
>> last year.
> 
> I have Gerd's patch sitting in my tree, but it's never really worked
> for me, so I haven't pushed it.
Yep, I tried them and it didn't work for me either, I'll try again though.

Antoine
