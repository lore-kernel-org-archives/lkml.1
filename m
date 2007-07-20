Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbXGTEfZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbXGTEfZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:35:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbXGTEfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:35:16 -0400
Received: from gateway.insightbb.com ([74.128.0.19]:47234 "EHLO
	asav07.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbXGTEfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:35:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlwPAFjYn0ZKhRO4Rmdsb2JhbACBTY14AQEBIwYM
From: Dmitry Torokhov <dtor@insightbb.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git pull] More input updates for post-2.6.22
Date: Fri, 20 Jul 2007 00:35:13 -0400
User-Agent: KMail/1.9.3
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200707180127.01614.dtor@insightbb.com>
In-Reply-To: <200707180127.01614.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707200035.14110.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wednesday 18 July 2007 01:27, Dmitry Torokhov wrote:
> Linus,
> 
> Please pull from:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input.git for-linus
> 
> or
> 
> 	master.kernel.org:/pub/scm/linux/kernel/git/dtor/input.git for-linus
> 
> to receive updates for input subsystem.
>

There are 2 more changes in the "for-linus" branch of my tree:

Dmitry Torokhov (1):
      Input: lifebook - fix an oops on Panasonic CF-18

Soeren Sonnenburg (1):
      Input: appletouch - improve powersaving for Geyser3 devices

 drivers/input/mouse/appletouch.c |  111 +++++++++++++++++++++++++-------------
 drivers/input/mouse/lifebook.c   |    2 +-
 2 files changed, 75 insertions(+), 38 deletions(-)

Please pull.

-- 
Dmitry
