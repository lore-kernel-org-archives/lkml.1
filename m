Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbZBCTSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbZBCTSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 14:18:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752142AbZBCTSU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 14:18:20 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755554AbZBCTST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 14:18:19 -0500
Date: Tue, 3 Feb 2009 20:18:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       x86@kernel.org
Subject: Re: mmotm 2009-02-02-17-12 uploaded (x86/nopmd etc.)
Message-ID: <20090203191804.GA24698@elte.hu>
References: <200902030112.n131CNiq010549@imap1.linux-foundation.org> <498893C8.6080506@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <498893C8.6080506@oracle.com>
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


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2009-02-02-17-12 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> > 
> > and will soon be available at
> > 
> >    git://git.zen-sources.org/zen/mmotm.git
> 
> 
> There seems to be some kind of #include hell here.  I moved a few lines
> around in include/asm-generic/pgtable-nopmd.h & that makes the build
> get further, but it still has header problems (BUG() is undefined).

problem caused by which commit?

	Ingo
