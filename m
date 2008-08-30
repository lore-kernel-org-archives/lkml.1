Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYH3UBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYH3UBS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 16:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYH3UBD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 16:01:03 -0400
Received: from aun.it.uu.se ([130.238.12.36]:37648 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbYH3UBB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 16:01:01 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18617.42725.154568.720643@harpo.it.uu.se>
Date: Sat, 30 Aug 2008 22:00:37 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: David Woodhouse <dwmw2@infradead.org>, fujita.tomonori@lab.ntt.co.jp,
       gregkh@suse.de, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 2.6.27-rc4-git7] mtd broken by cmdfilter move
In-Reply-To: <18617.36094.513546.806196@harpo.it.uu.se>
References: <200808301704.m7UH48Bn019083@harpo.it.uu.se>
	<1220116997.2982.5.camel@pmac.infradead.org>
	<18617.36094.513546.806196@harpo.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > David Woodhouse writes:
 >  > On Sat, 2008-08-30 at 19:04 +0200, Mikael Pettersson wrote:
 >  > > I'll leave it to you guys to decide what the proper fix for this mess
 >  > > should be.
 >  > 
 >  > I believe it's already been sent to Linus.
 > 
 > I can't find any mention of this in the post 2.6.27-rc5 commit log in
 > Linus' git tree as of right now. Care to provide a pointer to the fix?

Never mind, found it:
<http://lists.infradead.org/pipermail/linux-mtd/2008-August/022874.html>
