Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbXEXQzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbXEXQzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750871AbXEXQzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:55:36 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:59690 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750798AbXEXQzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:55:35 -0400
Date: Thu, 24 May 2007 09:55:33 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Jens Axboe <jens.axboe@oracle.com>
cc: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>,
       Hugh Dickins <hugh@veritas.com>, Ingo Molnar <mingo@elte.hu>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <20070524072550.GC15375@kernel.dk>
Message-ID: <Pine.LNX.4.64.0705240953270.28086@schroedinger.engr.sgi.com>
References: <376320.95285.qm@web52612.mail.re2.yahoo.com>
 <Pine.LNX.4.64.0705221524490.16904@schroedinger.engr.sgi.com>
 <20070523071103.GE4705@kernel.dk> <Pine.LNX.4.64.0705231003460.19822@schroedinger.engr.sgi.com>
 <20070524072550.GC15375@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Jens Axboe wrote:

> On Wed, May 23 2007, Christoph Lameter wrote:
> > On Wed, 23 May 2007, Jens Axboe wrote:
> > 
> > > That works for me with the patch, .config attached.
> > 
> > Hmmmm... That means the .config sent initially here was bogus.
> 
> ?
> 
> Considering we're trying to help you fix bugs in your code, you could be
> considerably more helpful.

I am trying figure out what is wrong and somehow that is not helpful? The 
data that we have right now about the bug does not give us a clear 
picture. One explanation that would have made it consistent would be that 
the .config posted was not reflecting the actual kernel in use.



