Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbXDUJsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbXDUJsd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 05:48:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXDUJsd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 05:48:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932493AbXDUJsc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 05:48:32 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Permanent Kgdb integration into the kernel - lets get with it.
Date: Sat, 21 Apr 2007 11:48:09 +0200
User-Agent: KMail/1.9.6
Cc: pdelaney@bluelane.com, Randy Dunlap <randy.dunlap@oracle.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Jason Wessel <jason.wessel@windriver.com>,
       Piet Delaney <piet@bluelane.com>, Tom Rini <trini@kernel.crashing.org>,
       Dave Jiang <djiang@mvista.com>, linux-kernel@vger.kernel.org,
       George Anzinger <george@wildturkeyranch.net>,
       "David O'Brien" <obrien@freebsd.org>
References: <20070307204516.GA24095@blade.az.mvista.com> <1177109495.9479.81.camel@piet2.bluelane.com> <20070420163450.d8c8b3b7.akpm@linux-foundation.org>
In-Reply-To: <20070420163450.d8c8b3b7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200704211148.09525.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Lots of people want kgdb.  One person is famously less keen on it, but
> we'll be able to talk him around, as long as the patches aren't daft.

The big question is if the kgdb developers seriously want mainline.
At least in the past this definitely wasn't the case.

If they're not open to change requests from mainline reviewers we don't
even need to bother to start the whole exercise.

Just putting their stuff onto korg isn't enough.

-Andi
