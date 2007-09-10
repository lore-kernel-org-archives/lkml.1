Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbXIJToY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbXIJToY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 15:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761010AbXIJToG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 15:44:06 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:50398 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760745AbXIJToE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 15:44:04 -0400
Date: Mon, 10 Sep 2007 12:44:01 -0700
From: Paul Jackson <pj@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: akpm@linux-foundation.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: Group short-lived and reclaimable kernel allocations
Message-Id: <20070910124401.5814acad.pj@sgi.com>
In-Reply-To: <20070910112211.3097.86408.sendpatchset@skynet.skynet.ie>
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie>
	<20070910112211.3097.86408.sendpatchset@skynet.skynet.ie>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Minor nit, Mel.

It's easier to read patches if you use the diff -p option:

       -p  --show-c-function
              Show which C function each change is in.

Thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
