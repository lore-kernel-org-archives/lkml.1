Return-Path: <linux-kernel-owner+w=401wt.eu-S935124AbXLNAqL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935124AbXLNAqL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 19:46:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764368AbXLNAp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 19:45:57 -0500
Received: from ns1.suse.de ([195.135.220.2]:36029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762584AbXLNAp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 19:45:56 -0500
Date: Thu, 13 Dec 2007 16:34:26 -0800
From: Greg KH <gregkh@suse.de>
To: Oliv?r Pint?r <oliver.pntr@gmail.com>
Cc: "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Chinner <dgc@sgi.com>,
       Lachlan McIlroy <lachlan@sgi.com>
Subject: Re: [patch 32/36] XFS: Make xfsbufd threads freezable
Message-ID: <20071214003426.GB10642@suse.de>
References: <20071213062511.265908583@mini.kroah.org> <20071213063529.GG25301@kroah.com> <F1D642E5A91BC94D9504EC83AE19E6B001520239@ecqcmtlmail3.quebec.int.ec.gc.ca> <6101e8c40712131107r23cda32p86d2a3e22a3adcb8@mail.gmail.com> <6101e8c40712131116n6446d564s1046e5f8914e7a0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6101e8c40712131116n6446d564s1046e5f8914e7a0a@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:16:46PM +0100, Oliv?r Pint?r wrote:
> http://lwn.net/Articles/235908/
> 
> or then drop this patch... while to big change are im kernel

It's now dropped.

Oliver, in the future, can you at least test the patches you wish to
have applied to the -stable tree?  :)

thanks,

greg k-h
