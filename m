Return-Path: <linux-kernel-owner+w=401wt.eu-S1033204AbXHMSyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033204AbXHMSyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 14:54:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932125AbXHMSmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 14:42:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:39637 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1033323AbXHMSmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 14:42:08 -0400
Date: Mon, 13 Aug 2007 20:42:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Gabriel C <nix.or.die@googlemail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Vitaly Bordug <vitb@kernel.crashing.org>,
       Dan Merillat <dan.merillat@gmail.com>,
       Paolo Ornati <ornati@fastwebnet.it>, Andi Kleen <andi@firstfloor.org>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-fsdevel@vger.kernel.org,
       nfs@lists.sourceforge.net, Jeff Garzik <jeff@garzik.org>,
       Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: [1/2] 2.6.23-rc3: known regressions with patches
Message-ID: <20070813184204.GA6071@one.firstfloor.org>
References: <46C09C1A.7050706@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46C09C1A.7050706@googlemail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Unclassified
> 
> Subject         : reset during bootup - 2.6.23-rc2 (git d23cf676)

This is already fixed in mainline

There is a real regression with failing builds on some old binutils on 
x86-64 know, but I don't know how to fix it.

-Andi
