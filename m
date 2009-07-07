Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbZGGPxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbZGGPxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbZGGPx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:53:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52146 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754676AbZGGPx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:53:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1246975428.3613.10.camel@ht.satnam>
References: <1246975428.3613.10.camel@ht.satnam>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: dhowells@redhat.com, trivial <trivial@kernel.org>,
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
Subject: Re: [GIT PULL] [PATCH 0/22] trivial fixes typo "foo foo"
Date: Tue, 07 Jul 2009 16:44:00 +0100
Message-ID: <16756.1246981440@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> Jaswinder Singh Rajput (22):
>       trivial: fix typo "has has" in multiple files
>       trivial: fix typo "on on" in multiple files
>       trivial: fix typo "that that" in multiple files

NAK.  You can't just mechanically reduce the above pairs of words to a single
instance unconditionally.

"has has" should perhaps be "has had" in some cases.

In "on on", the first preposition may be part of a compound verb (eg: "to go
on").

In "that that", the second "that" may be specifying the object in relation to
a previous part of the text.

David
