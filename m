Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbZFKSvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbZFKSvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756999AbZFKSv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:51:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42699 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZFKSv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:51:27 -0400
Date: Thu, 11 Jun 2009 14:51:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Newall <davidn@davidnewall.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       "David S. Miller" <davem@davemloft.net>,
       Stephane Eranian <eranian@googlemail.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] Performance Counters for Linux
Message-ID: <20090611185117.GA27411@infradead.org>
References: <20090611160329.GA3366@elte.hu> <20090611161714.GA5008@infradead.org> <alpine.LFD.2.01.0906110922080.3573@localhost.localdomain> <20090611165226.GV8633@ZenIV.linux.org.uk> <1244739378.6691.540.camel@laptop> <20090611170015.GA3651@infradead.org> <alpine.LFD.2.01.0906111005020.3573@localhost.localdomain> <84144f020906111059g6e25a090y4434cfd698f84fb4@mail.gmail.com> <4A3148AA.9000007@davidnewall.com> <alpine.LFD.2.01.0906111120100.3573@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906111120100.3573@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 11:21:46AM -0700, Linus Torvalds wrote:
> But I note (once more) how _nobody_ has actually been able to accept the 
> fact that oprofile was an abject failure as it was split up. Instead, you 
> all dance around totally irrelevant issues.

I don't think oprofile has been a desaster because of any kind of split,
but because the design has been a failure from day 1.

