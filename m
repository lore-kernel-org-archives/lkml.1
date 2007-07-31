Return-Path: <linux-kernel-owner+w=401wt.eu-S935875AbXGaAVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935875AbXGaAVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 20:21:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934259AbXGaAVJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 20:21:09 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47387 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079AbXGaAVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 20:21:06 -0400
Date: Tue, 31 Jul 2007 06:03:20 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keiichi Kii <k-keiichi@bx.jp.nec.com>, Netdev <netdev@vger.kernel.org>,
       Joel Becker <joel.becker@oracle.com>, Matt Mackall <mpm@selenic.com>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3 -mm 0/9] netconsole: Multiple targets and dynamic
 reconfigurability
In-Reply-To: <20070730171211.97e2f8f0.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707310559380.17287@enigma.security.iitk.ac.in>
References: <20070730024741.10828.48209.sendpatchset@enigma.security.iitk.ac.in>
 <20070730171211.97e2f8f0.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Jul 2007, Andrew Morton wrote:

> On Mon, 30 Jul 2007 08:17:41 +0530
> Satyam Sharma <satyam@infradead.org> wrote:
> 
> > [0/9] netconsole: Multiple targets and dynamic reconfigurability
> > 
> > This is v3 of the patchset
> 
> That all looks pretty reasonable, thanks.
> 
> Are we all comfortable with the attributions?  As I have it now, everything
> will go in as having been authored by yourself.  There is no formal (ie:
> understood-by-git) way of recording joint authorship, unfortunately.  But one
> can make a record of such things in the changelog.

Ok, making such a record would be good, if possible. I did see that the
"author" field for git commits can have only one entry, unfortunately,
and it turns out "Signed-off-by" and "Acked-by" have other meanings
attached that have to do with the patch-journey-from-author-to-you chain.
But I'd like these to be somehow marked as jointly authored, definitely.

> I'll queue this material up in the to-be-sent-to-davem queue.

Ok, thanks.


Satyam
