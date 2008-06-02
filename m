Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbYFBKcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbYFBKcz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 06:32:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751324AbYFBKcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 06:32:47 -0400
Received: from styx.suse.cz ([82.119.242.94]:35768 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751233AbYFBKcq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 06:32:46 -0400
Date: Mon, 2 Jun 2008 12:32:45 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Matthew Wilcox <matthew@wil.cx>
cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org, penberg@cs.helsinki.fi,
       dwmw2@infradead.org, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
In-Reply-To: <20080529163247.GW22636@parisc-linux.org>
Message-ID: <Pine.LNX.4.64.0806021231220.6718@jikos.suse.cz>
References: <1212010931.3445.103.camel@localhost.localdomain>
 <1212013125.2236.58.camel@shinybook.infradead.org>
 <1212014127.3445.115.camel@localhost.localdomain> <20080528.230934.131215087.davem@davemloft.net>
 <1212071813.3428.22.camel@localhost.localdomain> <Pine.LNX.4.64.0805291656000.6718@jikos.suse.cz>
 <20080529163247.GW22636@parisc-linux.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008, Matthew Wilcox wrote:

> > - fixing random bugs from kernel bugzilla is boring (spending 10 hours 
> >   looking for missing '=' doesn't really attract them)
> Perhaps you could try making the process of finding a kernel bug seem
> more exciting?  I doubt that most kernel bugs are a simple as a missing =.

Indeed. Large amount of kernel bugs is 'kernel doesn't work on this 
hardware setup X, other hardware setups are not affected". That doesn't 
sound too sexy either, unless you are unfortunate enough to have the piece 
of hardware in question, of course.

-- 
Jiri Kosina
SUSE Labs
