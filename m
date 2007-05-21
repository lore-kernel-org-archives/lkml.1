Return-Path: <linux-kernel-owner+w=401wt.eu-S1764150AbXEUWRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764150AbXEUWRU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 18:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758574AbXEUWRJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 18:17:09 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:33150 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758561AbXEUWRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 18:17:08 -0400
Date: Mon, 21 May 2007 15:13:07 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Chris Wright <chrisw@sous-sol.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/69] -stable review
Message-ID: <20070521221307.GP3429@sequoia.sous-sol.org>
References: <20070521191612.800400000@sous-sol.org> <20070521123148.a3dad5f2.akpm@linux-foundation.org> <20070521203111.GJ3429@sequoia.sous-sol.org> <46521165.5030207@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46521165.5030207@cosmosbay.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Dumazet (dada1@cosmosbay.com) wrote:
> Chris Wright a écrit :
> >* Andrew Morton (akpm@linux-foundation.org) wrote:
> >>On Mon, 21 May 2007 12:16:12 -0700
> >>Chris Wright <chrisw@sous-sol.org> wrote:
> >>
> >>>This is the start of the stable review cycle for the 2.6.21.2 release.
> >>Gee a lot of these are fixing recently-added regressions :(
> >>
> >>Did we fix oprofile on x86_64 yet?  If not, I'd suggest we should
> >>hold off 2.6.21.2 until we have done so.
> >
> >No, we've seen 2 versions of the patch, no word from Andi, and nothing
> >upstream that I saw.  Andi?
> 
> Seems Linus tree includes a fix from Andi, check commit 
> 6c977aad03a18019015035958c65b6729cd0574c

Indeed, it's there now.

thanks,
-chris
