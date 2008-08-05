Return-Path: <linux-kernel-owner+w=401wt.eu-S1762973AbYHEHRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762973AbYHEHRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYHEHRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 03:17:21 -0400
Received: from gate.crashing.org ([63.228.1.57]:45254 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbYHEHRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 03:17:20 -0400
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux,
	post-2.6.27-rc1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Paul Collins <paul@burly.ondioline.org>
Cc: michael@ellerman.id.au, "J. Bruce Fields" <bfields@fieldses.org>,
       Neil Brown <neilb@suse.de>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <871w145ar3.fsf@burly.wgtn.ondioline.org>
References: <20080802184554.GB715@fieldses.org>
	 <87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	 <877iayy4qc.fsf@burly.wgtn.ondioline.org>
	 <18581.40960.737792.454035@notabene.brown>
	 <87r696l1yo.fsf@burly.wgtn.ondioline.org>
	 <18582.32935.501672.689845@notabene.brown>
	 <87fxpll5zq.fsf@burly.wgtn.ondioline.org>
	 <87y73dcd60.fsf@burly.wgtn.ondioline.org>
	 <1217860597.12535.2.camel@localhost>
	 <87hca05ws4.fsf@burly.wgtn.ondioline.org>
	 <20080804205908.GA29890@fieldses.org> <1217895418.7951.7.camel@localhost>
	 <8763qg5don.fsf@burly.wgtn.ondioline.org>
	 <1217910862.7951.22.camel@localhost>
	 <871w145ar3.fsf@burly.wgtn.ondioline.org>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 17:16:58 +1000
Message-Id: <1217920618.24157.161.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-05 at 16:47 +1200, Paul Collins wrote:
> It's about four years old.  It was in storage for about six months and I
> got it repaired a few weeks ago (display cable and inverter).  The sort
> of crazy crap I've been reporting certainly smacks of memory corruption.
> But on the other hand, 2.6.25 (Debian's) and 2.6.26 (my own) have been
> trouble-free.

Any chance you can bisect the problem ?

Cheers,
Ben.

