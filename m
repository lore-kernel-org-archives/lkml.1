Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZIVMgM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZIVMgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 08:36:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbZIVMgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 08:36:11 -0400
Received: from smtp.nokia.com ([192.100.105.134]:65458 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098AbZIVMgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 08:36:10 -0400
Message-ID: <4AB8C429.60804@gmail.com>
Date: Tue, 22 Sep 2009 15:33:45 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: torvalds@linux-foundation.org
CC: tomi.valkeinen@nokia.com,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org, tony@atomide.com, linux-omap@vger.kernel.org,
       linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL]: OMAP2/3 Display Subsystem
References: <1253622588.25232.11.camel@tubuntu>
In-Reply-To: <1253622588.25232.11.camel@tubuntu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Sep 2009 12:35:48.0132 (UTC) FILETIME=[364D0E40:01CA3B81]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2009 03:29 PM, Tomi Valkeinen wrote:
> Linus,
>
> Here's the new display subsystem and framebuffer driver for OMAP2/3.
>
> The driver has been reviewed on linux-omap and linux-fbdev-devel, and is in
> use, for example, on N900, Beagle Board and Overo boards. We have an ACK for
> the OMAP parts from Tony Lindgren, who maintains the OMAP platform.
>
> We have gotten positive feedback about the driver, for example in this thread:
> http://marc.info/?l=linux-kernel&m=125171081901820&w=2
>
> The driver is actively maintained and developed further, and I have already a
> bunch of patches on top of these patches, but I would like to get the big core
> driver merged first. After the driver is merged, other people can send patches
> to LCD drivers and board files to enable the new display subsystem on their
> boards.
>
> Andrew said 2-3 weeks ago that he'll merge the driver (after he has looked
> through it), but he hasn't responded since then. I'm guessing he's quite busy.

Just in case it matters, here is my redundant confirmation that we are
successfully using this piece of software for about a year.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
