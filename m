Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbXGJTH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbXGJTH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 15:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756274AbXGJTHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 15:07:50 -0400
Received: from thunk.org ([69.25.196.29]:46469 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbXGJTHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 15:07:49 -0400
Date: Tue, 10 Jul 2007 15:07:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Amit Arora <aarora@in.ibm.com>,
       Andi Kleen <ak@suse.de>, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: Re: fallocate-implementation-on-i86-x86_64-and-powerpc.patch (was: re: -mm merge plans for 2.6.23)
Message-ID: <20070710190735.GF27033@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Amit Arora <aarora@in.ibm.com>,
	Andi Kleen <ak@suse.de>, Paul Mackerras <paulus@samba.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Mark Fasheh <mark.fasheh@oracle.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710115251.GG2343@thunk.org> <20070710101558.cea7aab1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710101558.cea7aab1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 10:15:58AM -0700, Andrew Morton wrote:
> So I dropped everything.  Let's start again from scratch.  I'd suggest that
> for now we go with just an i386/x86_64 implementation, let the arch
> maintainers wire things up when that has settled down.

Ok, so no objections if we push the i386/x86_64 implementation (only),
plus the ext4 support to Linus?

						- Ted


