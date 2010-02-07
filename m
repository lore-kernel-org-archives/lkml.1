Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0BGEyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Feb 2010 23:54:45 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:41676 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753759Ab0BGEyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Feb 2010 23:54:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkBAHLWbUtLd/sX/2dsb2JhbAAIgyrFY48dgS+CSlsE
X-IronPort-AV: E=Sophos;i="4.49,420,1262581200"; 
   d="scan'208";a="55478359"
Message-ID: <4B6E4793.3010201@teksavvy.com>
Date: Sat, 06 Feb 2010 23:54:43 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.33-rc7
References: <alpine.LFD.2.00.1002061422430.3829@localhost.localdomain> <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002061445210.3829@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Do people really care about the old-fashioned tar.gz and patch.gz files? 
> I've always uploaded the tar-files and patches compressed with gzip, 
> because that's the "traditional" way, and then we have a script that also 
> re-compresses things as 'bz2' because it compresses better and many people 
> are bandwidth-limited and much prefer the better compression.
..

I prefer the .gz files, despite limited bandwidth here.
My older, slower CPUs cope with them better.

But .bz2-only would be fine as well.

I just wish the GNU tar folk had the sense to combine -z and -j
into a single flag.

-ml
