Return-Path: <linux-kernel-owner+w=401wt.eu-S1762812AbZBECon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762812AbZBECon (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:44:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762678AbZBECoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:44:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63544 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756271AbZBECob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:44:31 -0500
Message-ID: <498A5265.9020107@cn.fujitsu.com>
Date: Thu, 05 Feb 2009 10:43:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for February 3 (can't boot)
References: <20090203173616.ef3dec8a.sfr@canb.auug.org.au>
In-Reply-To: <20090203173616.ef3dec8a.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20090202:
> 

I can't boot up linux-next-20090203. When booting, The box reset itself
immediately, before I can see anything.

I was not using pure linux-next. I was using mm tree, but it failed to
boot, so I did "quilt pop linux-next.patch", and there were still some
bug-fix patches before linux-next.patch.

Haven't tried 20090204.

