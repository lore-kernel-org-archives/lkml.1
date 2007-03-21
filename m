Return-Path: <linux-kernel-owner+w=401wt.eu-S1752859AbXCUN7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbXCUN7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 09:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXCUN7m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 09:59:42 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57858 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbXCUN7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 09:59:41 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Artem Bityutskiy <dedekind@infradead.org>, Matt Mackall <mpm@selenic.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <20070321135033.GA7235@thunk.org>
References: <20070319170838.GP4892@waste.org>
	 <1174328188.30079.46.camel@zod.rchland.ibm.com>
	 <20070319195442.GT4892@waste.org> <1174338393.17249.53.camel@sauron>
	 <20070319213628.GW4892@waste.org> <1174393549.17249.101.camel@sauron>
	 <20070320135231.GA6043@thunk.org>
	 <1174406395.30079.139.camel@zod.rchland.ibm.com>
	 <20070320220312.GC29493@thunk.org> <1174466675.17249.182.camel@sauron>
	 <20070321135033.GA7235@thunk.org>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 08:59:28 -0500
Message-Id: <1174485568.3416.59.camel@zod.rchland.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 09:50 -0400, Theodore Tso wrote:
> 
> And at this point, I don't doubt that you will at some point going to
> heed my comments --- but note that doing so will involve a massive
> refactorization of the code, which will tend to invalidate the reviews
> done of this current (take 3) version of the patches; so I am bit
> curious what was your motiviation in reposting this round of the
> patches.  

Yes.  However, nobody has actually reviewed any of the _code_ in this
round.  So while it may have been somewhat superfluous from a submission
standpoint, at least no code review has been wasted and we are getting
some fairly decent design discussions.

josh

