Return-Path: <linux-kernel-owner+w=401wt.eu-S1755997AbXEUUe6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997AbXEUUe6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:34:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753689AbXEUUet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:34:49 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:48009 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754946AbXEUUes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:34:48 -0400
Date: Mon, 21 May 2007 13:31:11 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Andi Kleen <ak@suse.de>,
       "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Justin Forbes <jmforbes@linuxtx.org>, linux-kernel@vger.kernel.org,
       Chris Wedgwood <reviews@ml.cw.f00f.org>, Chuck@hera.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Michael Krufky <mkrufky@linuxtv.org>, Ebbert <cebbert@redhat.com>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       stable@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [stable] [patch 00/69] -stable review
Message-ID: <20070521203111.GJ3429@sequoia.sous-sol.org>
References: <20070521191612.800400000@sous-sol.org> <20070521123148.a3dad5f2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070521123148.a3dad5f2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Mon, 21 May 2007 12:16:12 -0700
> Chris Wright <chrisw@sous-sol.org> wrote:
> 
> > This is the start of the stable review cycle for the 2.6.21.2 release.
> 
> Gee a lot of these are fixing recently-added regressions :(
> 
> Did we fix oprofile on x86_64 yet?  If not, I'd suggest we should
> hold off 2.6.21.2 until we have done so.

No, we've seen 2 versions of the patch, no word from Andi, and nothing
upstream that I saw.  Andi?

> I assume ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/oprofile-allocation
> is what we want.
