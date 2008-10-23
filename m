Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbYJWIkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbYJWIkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYJWIki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:40:38 -0400
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:41233 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750850AbYJWIkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:40:36 -0400
Message-ID: <4900388A.7010406@lougher.demon.co.uk>
Date: Thu, 23 Oct 2008 09:40:42 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
CC: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed read-only filesystem
References: <E1KqrTW-0001x8-3h@dylan> <Pine.LNX.4.64.0810221913330.20919@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0810221913330.20919@vixen.sonytel.be>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> 	Hi Phillip,
> 
> On Fri, 17 Oct 2008, Phillip Lougher wrote:
>> This is a second attempt at mainlining Squashfs.  The first attempt was way
> 
> This is great news!
> 
> I ran a quick test of squashfs 4.0 (the CVS version) on UML/ia32 and ppc64, and it
> seems to work fine!  Great job! Let's hope we'll see it in mainline soon...
> 

Thanks!  I hope it gets into mainline soon too :)

> BTW, one minor gripe is that the current mksquashfs doesn't want to run on big
> endian yet, as there's no byteswapping support.

Yeah, I know about that.  There's still some work needing to be done on 
the squashfs-tools.  I figured it was important to get the kernel stuff 
submitted and discussed ASAP.

Phillip

