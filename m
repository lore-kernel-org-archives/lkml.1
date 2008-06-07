Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbYFGTwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbYFGTwp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 15:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750944AbYFGTwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 15:52:38 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:32946 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbYFGTwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 15:52:37 -0400
Message-ID: <484AE6FF.7030405@krogh.cc>
Date: Sat, 07 Jun 2008 21:52:31 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc5
References: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806042018060.3473@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is another one .. very noisy, but still not something that
seems to effect the usability of the system.

[   26.738367] ck804xrom ck804xrom_init_one(): Unable to register 
resource 0x00000000ffb00000-0x00000000ffffffff - kernel bug?
[   26.758371] CFI: Found no ck804xrom @ffc00000 device at location zero
[   26.798790] JEDEC: Found no ck804xrom @ffc00000 device at location zero
[   26.798790] CFI: Found no ck804xrom @ffc00000 device at location zero
[   26.798790] JEDEC: Found no ck804xrom @ffc00000 device at location zero
[   26.798790] CFI: Found no ck804xrom @ffc00000 device at location zero
[   26.798790] JEDEC: Found no ck804xrom @ffc00000 device at location zero
[   26.798790] CFI: Found no ck804xrom @ffc10000 device at location zero
[   26.798790] JEDEC: Found no ck804xrom @ffc10000 device at location zero
[   26.798790] CFI: Found no ck804xrom @ffc10000 device at location zero
[   26.798790] JEDEC: Found no ck804xrom @ffc10000 device at location zero
[   26.798790] CFI: Found no ck804xrom @ffc10000 device at location zero
... and so on.. 192 times.

full dmesg here http://krogh.cc/~jesper/dmesg

-- 
Jesper Krogh
