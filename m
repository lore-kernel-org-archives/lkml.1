Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbYGEXhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbYGEXhK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 19:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYGEXg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 19:36:59 -0400
Received: from relay03.mail-hub.dodo.com.au ([123.2.6.238]:41650 "EHLO
	relay03.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbYGEXg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 19:36:58 -0400
From: Grant Coady <grant_lkml@dodo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc9
Date: Sun, 06 Jul 2008 09:36:30 +1000
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <f31074112h7jusi98q1a7ln3g2nhi6k5ko@4ax.com>
References: <alpine.LFD.1.10.0807051557500.3016@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807051557500.3016@woody.linux-foundation.org>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jul 2008 16:15:14 -0700 (PDT), Linus Torvalds <torvalds@linux-foundation.org> wrote:

>
>Ok, the last -rc obviously wasn't the last one after all, since here's a 
>new one. Enough changes that we needed another -rc, and the regression 
>list isn't emptying fast enough either (probably because a number of 
>people, including reporters, are vacationing).

Noticed the stale LATEST-IS-* entries no longer being removed at:
  http://www.kernel.org/pub/linux/kernel/v2.6/testing/?C=N;O=A
...
ChangeLog-2.6.26-rc8          25-Jun-2008 02:14   56K  
LATEST-IS-2.6.26-rc3          18-May-2008 21:46    0   
LATEST-IS-2.6.26-rc4          26-May-2008 18:17    0   
LATEST-IS-2.6.26-rc5          05-Jun-2008 03:17    0   
LATEST-IS-2.6.26-rc6          12-Jun-2008 21:45    0   
LATEST-IS-2.6.26-rc7          20-Jun-2008 23:44    0   
LATEST-IS-2.6.26-rc8          25-Jun-2008 02:14    0   
linux-2.6.26-rc1.tar.bz2      03-May-2008 19:40   47M  
...

Grant.
