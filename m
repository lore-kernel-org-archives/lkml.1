Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbYH3SS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbYH3SS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 14:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYH3SSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 14:18:51 -0400
Received: from aun.it.uu.se ([130.238.12.36]:36638 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752835AbYH3SSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 14:18:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18617.36094.513546.806196@harpo.it.uu.se>
Date: Sat, 30 Aug 2008 20:10:06 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, fujita.tomonori@lab.ntt.co.jp,
       gregkh@suse.de, jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION 2.6.27-rc4-git7] mtd broken by cmdfilter move
In-Reply-To: <1220116997.2982.5.camel@pmac.infradead.org>
References: <200808301704.m7UH48Bn019083@harpo.it.uu.se>
	<1220116997.2982.5.camel@pmac.infradead.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse writes:
 > On Sat, 2008-08-30 at 19:04 +0200, Mikael Pettersson wrote:
 > > I'll leave it to you guys to decide what the proper fix for this mess
 > > should be.
 > 
 > I believe it's already been sent to Linus.

I can't find any mention of this in the post 2.6.27-rc5 commit log in
Linus' git tree as of right now. Care to provide a pointer to the fix?
