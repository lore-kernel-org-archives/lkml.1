Return-Path: <linux-kernel-owner+w=401wt.eu-S1755395AbYGDVMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395AbYGDVMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 17:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYGDVMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 17:12:12 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44276 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYGDVMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:12:12 -0400
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Woodhouse <dwmw2@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, andi@firstfloor.org,
       tytso@mit.edu, hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
In-Reply-To: <20080704135901.51b6b6e2@linux.intel.com>
References: <1215178035.10393.763.camel@pmac.infradead.org>
	 <20080704.133721.98729739.davem@davemloft.net>
	 <20080704134208.6c712031@infradead.org>
	 <20080704.135150.250580915.davem@davemloft.net>
	 <20080704135901.51b6b6e2@linux.intel.com>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 22:12:03 +0100
Message-Id: <1215205923.3189.28.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-04 at 13:59 -0700, Arjan van de Ven wrote:
> On Fri, 04 Jul 2008 13:51:50 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> > Yet that is exactly the impression that I have gotten over
> > all of the communication I've received.
> > 
> 
> then I'd like to set that impression straight (and burry the
> conspiracy theories)... I've never asked David to do this for any kind
> of legal theory or otherwise. Any of it, tg3 or otherwise. And while I
> can't speak for Intel on legal aspects (if there are any here), I can
> speak as Davids manager that this entire project hasn't originated from
> anything we (Intel) asked him to do.

I wouldn't worry, Arjan. There is no basis for Dave's claim, and he
knows perfectly well I was working on it before I was working for Intel.

It's perfectly sensible janitorial-type work which has needed doing for
ages, and which I got interested in after a discussion about the kernel
that Fedora ships.

The Fedora Engineering Steering Committee (of which I'm a member) agreed
that Fedora would _like_ to ship a firmware-less kernel, if that was
technically feasible (and didn't involve actually breaking drivers).

-- 
dwmw2

