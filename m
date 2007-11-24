Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbXKXMEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbXKXMEY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 07:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbXKXMEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 07:04:16 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36706 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbXKXMEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 07:04:16 -0500
Date: Sat, 24 Nov 2007 21:04:37 +0900
From: kosaki <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.24-rc3-mm1 (sync is slow ?)
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071121004909.6157bb9a.akpm@linux-foundation.org>
References: <20071121174215.caff4551.kamezawa.hiroyu@jp.fujitsu.com> <20071121004909.6157bb9a.akpm@linux-foundation.org>
Message-Id: <20071124190604.276B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew 

> > Hi, Andrew
> > 
> > I got following result in 'sync' command.
> > It was too slow. (memory controller config is off ;)
> > I attaches my .config.
> > ==
 (snip)
> 
> Well I wonder how we did that.
> 
> It seems OK here from a quick test (i386, ext3-on-IDE).
> 
> Maybe device driver/block breakage?

I tested x86, ext3-on-SATA(/dev/sda).
It seems works well.

Hmm...


-- 
kosaki


