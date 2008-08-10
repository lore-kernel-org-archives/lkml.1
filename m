Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbYHJBAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbYHJBAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 21:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752706AbYHJBAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 21:00:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:59178 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYHJBAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 21:00:07 -0400
Date: Sat, 9 Aug 2008 19:00:06 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Grant Grundler <grundler@parisc-linux.org>
Cc: Adrian Bunk <bunk@kernel.org>, kyle@mcmartin.ca,
       linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, bdale@hp.com
Subject: Re: [2.6 patch] binfmt_som.c: add MODULE_LICENSE
Message-ID: <20080810010005.GL8618@parisc-linux.org>
References: <20080806211155.GV1702@cs181140183.pp.htv.fi> <20080810005511.GB2617@colo.lackof.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080810005511.GB2617@colo.lackof.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 09, 2008 at 06:55:11PM -0600, Grant Grundler wrote:
> Someone from HP needs to ACK this patch since I believe HP funded the code
> changes made during the parisc-linux port. This should be a no-brainer
> and I expect Bdale Garbee can quickly take care of this.

I actually did the work here, it was derived heavily from binfmt_elf
and binfmt_aout; had it not been GPL-licensed, it would not have been
distributable.  Also, I believe I did this work before joining Linuxcare,
so I don't believe HP has any claim to it at all.  You'd have to check
CVS history to be sure.  Oh, and even if HP does have a claim to it
through Linuxcare, HP's contract required all changes made by Linuxcare
to be contributed upstream.  So three different reasons why this code
being GPL is required.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
