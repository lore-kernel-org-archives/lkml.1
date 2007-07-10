Return-Path: <linux-kernel-owner+w=401wt.eu-S1761003AbXGJRot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761003AbXGJRot (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXGJRol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:44:41 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60915 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbXGJRok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:44:40 -0400
Message-ID: <4693C580.2000506@garzik.org>
Date: Tue, 10 Jul 2007 13:44:32 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       Amit Arora <aarora@in.ibm.com>, Andi Kleen <ak@suse.de>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>, "Luck, Tony" <tony.luck@intel.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Mark Fasheh <mark.fasheh@oracle.com>, linux-arch@vger.kernel.org
Subject: Re: fallocate-implementation-on-i86-x86_64-and-powerpc.patch
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>	<20070710115251.GG2343@thunk.org> <20070710101558.cea7aab1.akpm@linux-foundation.org>
In-Reply-To: <20070710101558.cea7aab1.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> So I dropped everything.  Let's start again from scratch.  I'd suggest that
> for now we go with just an i386/x86_64 implementation, let the arch
> maintainers wire things up when that has settled down.


It's my observation that that plan usually works the best.  Arch 
maintainers come along and wire up batches of syscalls when they have a 
chance to glance at the ABI, and catch up with x86[-64].

	Jeff




