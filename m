Return-Path: <linux-kernel-owner+w=401wt.eu-S1764207AbXGKASI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764207AbXGKASI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 20:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754531AbXGKAR5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 20:17:57 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50312 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbXGKAR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 20:17:56 -0400
Date: Tue, 10 Jul 2007 17:16:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Amit Arora <aarora@in.ibm.com>,
       Andi Kleen <ak@suse.de>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mark Fasheh <mark.fasheh@oracle.com>, linux-arch@vger.kernel.org
Subject: Re: fallocate-implementation-on-i86-x86_64-and-powerpc.patch
Message-Id: <20070710171650.642881db.akpm@linux-foundation.org>
In-Reply-To: <18068.5612.100418.782729@cargo.ozlabs.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710115251.GG2343@thunk.org>
	<20070710101558.cea7aab1.akpm@linux-foundation.org>
	<4693C580.2000506@garzik.org>
	<18068.5612.100418.782729@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 09:27:40 +1000
Paul Mackerras <paulus@samba.org> wrote:

> We did come up with an order that worked for everybody, but that
> discussion seemed to get totally ignored by the ext4 developers.

It was a long discussion.

Can someone please remind us what the signature of the syscall
(and the compat handler) should be?
