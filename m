Return-Path: <linux-kernel-owner+w=401wt.eu-S1753823AbYKMV2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbYKMV2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:28:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYKMV1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:27:54 -0500
Received: from styx.suse.cz ([82.119.242.94]:57672 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753185AbYKMV1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:27:53 -0500
Date: Thu, 13 Nov 2008 22:27:52 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Ingo Molnar <mingo@elte.hu>
cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       oprofile-list@lists.sf.net, Jiri Benc <jbenc@suse.cz>,
       Vilem Marsik <vmarsik@suse.cz>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Oprofile [still] doesn't work on 2.6.28-rc4 on certain CPU
In-Reply-To: <20081113212446.GA5694@elte.hu>
Message-ID: <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz>
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Nov 2008, Ingo Molnar wrote:

> > I haven't yet found a time to start bisecting this.
> Would be nice to identify a commit to revert - in case we run out of 
> time fixing it.

Yup, I first wanted to make this known to the public in hope that it will 
ring a bell somewhere.

If noone sees an obvous reason for this, I will do my best to bisect this 
tomorrow.

-- 
Jiri Kosina
SUSE Labs
