Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbZGGQsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbZGGQsU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 12:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756350AbZGGQsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 12:48:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:56232 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669AbZGGQsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 12:48:12 -0400
Subject: Re: [GIT PULL] [PATCH 0/22] trivial fixes typo "foo foo"
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: trivial <trivial@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Randy Dunlap <randy.dunlap@oracle.com>, Tony Luck <tony.luck@intel.com>,
       benh@kernel.crashing.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       mchehab@infradead.org, jbarnes@virtuousgeek.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg Ungerer <gerg@snapgear.com>, Greg KH <greg@kroah.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Ingo Molnar <mingo@elte.hu>, tytso@mit.edu, sct@redhat.com,
       Gadiyar Anand <gadiyar@ti.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <16756.1246981440@redhat.com>
References: <1246975428.3613.10.camel@ht.satnam>
	 <16756.1246981440@redhat.com>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 22:16:39 +0530
Message-Id: <1246985199.3613.50.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello David,

On Tue, 2009-07-07 at 16:44 +0100, David Howells wrote:
> Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> 
> > Jaswinder Singh Rajput (22):
> >       trivial: fix typo "has has" in multiple files
> >       trivial: fix typo "on on" in multiple files
> >       trivial: fix typo "that that" in multiple files
> 
> NAK.  You can't just mechanically reduce the above pairs of words to a single
> instance unconditionally.
> 
> "has has" should perhaps be "has had" in some cases.
> 
> In "on on", the first preposition may be part of a compound verb (eg: "to go
> on").
> 
> In "that that", the second "that" may be specifying the object in relation to
> a previous part of the text.
> 

Thanks for your feed-back.

I removed all the patches pointed by you and also removed some more
patches which can create confusion.

Please check new pull request, and let me know if you found some more
issues :

[GIT PULL] V2 trivial fixes typo "foo foo"

Thanks,
--
JSR

