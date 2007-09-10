Return-Path: <linux-kernel-owner+w=401wt.eu-S1760923AbXIJUQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760923AbXIJUQJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 16:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbXIJUP4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 16:15:56 -0400
Received: from gir.skynet.ie ([193.1.99.77]:59459 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbXIJUP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 16:15:56 -0400
Subject: Re: Group short-lived and reclaimable kernel allocations
From: Mel Gorman <mel@csn.ul.ie>
To: Paul Jackson <pj@sgi.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20070910124401.5814acad.pj@sgi.com>
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
	 <20070910112211.3097.86408.sendpatchset@skynet.skynet.ie>
	 <20070910124401.5814acad.pj@sgi.com>
Content-Type: text/plain
Date: Mon, 10 Sep 2007 22:15:55 +0100
Message-Id: <1189458955.9900.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-10 at 12:44 -0700, Paul Jackson wrote:
> Minor nit, Mel.
> 
> It's easier to read patches if you use the diff -p option:
> 
>        -p  --show-c-function
>               Show which C function each change is in.
> 

That's a fair comment. I normally make sure it's there but it got missed
in a few patches in this set which is awkward. Sorry about that.

-- 
Mel Gorman

