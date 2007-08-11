Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXHKS6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXHKS6B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 14:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158AbXHKS5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 14:57:50 -0400
Received: from 1wt.eu ([62.212.114.60]:1433 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756714AbXHKS5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 14:57:45 -0400
From: Willy Tarreau <w@1wt.eu>
Message-Id: <20070811184752.%N@1wt.eu>
User-Agent: quilt/0.46-1
Date: Sat, 11 Aug 2007 20:47:52 +0200
To: linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [2.6.20.16 review 00/28] 2.6.20.16 -stable review
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I proposed Chris and Greg to continue issuing a few more 2.6.20 releases
during the time needed for 2.6.21 and 2.6.22 to show a significant drop
in their patch rates, which hopefully will be just a matter of a few
releases.

My goal is *not* to do all the hard work they do, but just to backport
from their patches those which are meaningful for 2.6.20. For this
reason, 2.6.20 releases will always be slightly late and should not
contain patches not merged in more recent releases.

My intent with this version is to catch up with 2.6.21.7. Other patches
are already pending for future releases, but one thing at a time. I'm
trying to follow the same review/release process, so 28 patches will
be posted for review in response to this message.

If some people think it's useless to repost individual patches that have
already been reviewed in more recent versions, I'm open to adapting the
process (eg: switch to one mail for -rc and one for release like Adrian
does with 2.6.16).

The rolled up patch can be found here :
   ftp.kernel.org/pub/linux/kernel/v2.6/stable-review/patch-2.6.20.16-rc1.gz

Responses should be made by August 13, 2007, 20:00:00 UTC. Anything
received after that time might be too late.

Thanks,
Willy

--
