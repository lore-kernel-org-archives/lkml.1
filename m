Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZEKMt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZEKMt5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 08:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbZEKMta
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 08:49:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:39799 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757976AbZEKMt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 08:49:28 -0400
Date: Mon, 11 May 2009 14:49:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Joerg Roedel <joerg.roedel@amd.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [GIT PULL] xen: dom0 support for PCI access
Message-ID: <20090511124906.GM13954@elte.hu>
References: <1241732737-7669-1-git-send-email-jeremy@goop.org> <20090508111024.GD11596@elte.hu> <20090508124436.GT8112@parisc-linux.org> <4A05A493.7050107@goop.org> <20090509200805.GA26487@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090509200805.GA26487@parisc-linux.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Matthew Wilcox <matthew@wil.cx> wrote:

> On Sat, May 09, 2009 at 08:43:15AM -0700, Jeremy Fitzhardinge wrote:
> > Thanks.  Can I put your acked-by on those 7 changes (after fixing the  
> > __init thing Yinghai mentioned)?
> 
> Certainly, though I think Reviewed-by would be more appropriate?
> 
> Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

Yes, they are even more valuable.

	Ingo
