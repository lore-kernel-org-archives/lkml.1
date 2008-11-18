Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbYKRQs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbYKRQs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:48:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752843AbYKRQsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:48:50 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:21066 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYKRQst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:48:49 -0500
Date: Tue, 18 Nov 2008 08:47:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: procedures
Message-Id: <20081118084757.5c92c878.randy.dunlap@oracle.com>
In-Reply-To: <20081112173807.05cfadf0.sfr@canb.auug.org.au>
References: <20081112173807.05cfadf0.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4922F1BF.009E:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 17:38:07 +1100 Stephen Rothwell wrote:

...

> The following will cause a tree to be temporarily dropped from linux-next:
> 	- non-trivial conflicts with Linus' tree
> 	- build failures

Hi Stephen,
One clarification, please.

Does this mean build failures that _you_ see/experience during tree merging
and not other reported build failures?

Thanks,
~Randy


> 	- non-obvious conflicts with other trees (this will require
> us to come up with some way forward for the trees involved)
> 	- the contact for the tree being unresponsive
> 
> Most conflicts will be notified to the contacts for the trees involved
> (some really trivial ones will not).  Simple conflicts between trees I
> will try to fix up (if possible) and carry such resolutions as necessary.
> 
> I will not, any more, carry fix up patches to make linux-next build or
> boot.  If a tree is identified as causing such a problem, it will be
> dropped until the problem is fixed.
> 
> This is all open to discussion ...
