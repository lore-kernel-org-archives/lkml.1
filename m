Return-Path: <linux-kernel-owner+w=401wt.eu-S1752860AbXCUODS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbXCUODS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 10:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbXCUODS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 10:03:18 -0400
Received: from smtp.nokia.com ([131.228.20.172]:23054 "EHLO
	mgw-ext13.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbXCUODR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 10:03:17 -0400
Subject: Re: [PATCH 00/22 take 3] UBI: Unsorted Block Images
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Theodore Tso <tytso@mit.edu>
Cc: Josh Boyer <jwboyer@linux.vnet.ibm.com>, Matt Mackall <mpm@selenic.com>,
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
Content-Type: text/plain; charset=utf-8
Date: Wed, 21 Mar 2007 16:02:35 +0200
Message-Id: <1174485755.17249.206.camel@sauron>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 21 Mar 2007 14:02:35.0365 (UTC) FILETIME=[93AAC150:01C76BC1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-21 at 09:50 -0400, Theodore Tso wrote:
> And at this point, I don't doubt that you will at some point going to
> heed my comments --- but note that doing so will involve a massive
> refactorization of the code, which will tend to invalidate the reviews
> done of this current (take 3) version of the patches; so I am bit
> curious what was your motiviation in reposting this round of the
> patches.  

Well, in take 3 I _already_ removed quite _a lot_ of itsy-bitsy units,
and I thought it is enough, so I've submitted it. But later I've
realized that I should go further (e.g., dispose of per-unit data
structures), and started more re-work. Yes, I should have notified about
this new re-work, apologies.

Point taken, will be fixed :-)

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

