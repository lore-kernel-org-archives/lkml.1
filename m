Return-Path: <linux-kernel-owner+w=401wt.eu-S1761023AbYD3NEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761023AbYD3NEh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 09:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755898AbYD3NE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 09:04:28 -0400
Received: from eth7959.sa.adsl.internode.on.net ([150.101.82.22]:34829 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752786AbYD3NE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 09:04:27 -0400
Message-ID: <48186E57.5070805@davidnewall.com>
Date: Wed, 30 Apr 2008 22:34:23 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: Slow DOWN, please!!!
References: <20080429.190352.137408408.davem@davemloft.net>	<4817EF91.4080800@davidnewall.com> <20080429.211835.130816277.davem@davemloft.net>
In-Reply-To: <20080429.211835.130816277.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> We're having ONE bad merge window, we're facing the problem
> head on, RIGHT NOW, to prevent it in the future.  It's
> not a severe ongoing issue as you portray it to be.

No.  The problem is more than just a bad merge window.  There is poor or
non-existent review; frequent "regressions"; release of kernels as
stable when they are not.  There is resentment and resistance to even
acknowledging these problems.  Take, as an example, the desire to NOT
record who gives good code and who gives bugs: that one clearly hit a
nerve, which it should not have except from people who feel guilty.

I don't claim BSD to be perfect, but it appears to have a consistently
good quality.  Old Linux kernels also have that; new ones not so.
