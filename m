Return-Path: <linux-kernel-owner+w=401wt.eu-S1759342AbXJZRFF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342AbXJZRFF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:05:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757761AbXJZREz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:04:55 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:56961 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750849AbXJZREy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:04:54 -0400
Date: Fri, 26 Oct 2007 10:04:51 -0700
From: Paul Jackson <pj@sgi.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: rientjes@google.com, clameter@sgi.com, akpm@linux-foundation.org,
       ak@suse.de, linux-kernel@vger.kernel.org, mtk-manpages@gmx.net
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071026100451.c0742740.pj@sgi.com>
In-Reply-To: <1193413054.5032.20.camel@localhost>
References: <alpine.DEB.0.9999.0710251540210.11929@chino.kir.corp.google.com>
	<alpine.DEB.0.9999.0710251541550.11929@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251635420.9635@schroedinger.engr.sgi.com>
	<alpine.DEB.0.9999.0710251648430.23810@chino.kir.corp.google.com>
	<Pine.LNX.4.64.0710251725440.10197@schroedinger.engr.sgi.com>
	<20071025185506.8c373aa8.pj@sgi.com>
	<alpine.DEB.0.9999.0710251900080.8024@chino.kir.corp.google.com>
	<20071025192945.82962eea.pj@sgi.com>
	<alpine.DEB.0.9999.0710251937100.2989@chino.kir.corp.google.com>
	<20071025201455.acb4e72c.pj@sgi.com>
	<alpine.DEB.0.9999.0710252049590.18868@chino.kir.corp.google.com>
	<1193413054.5032.20.camel@localhost>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee wrote:
> Paul:  what do you think about subsetting the cpuset.txt into a man page
> or 2 that can be referenced by other man pages' See Also sections?

Oh dear --- looking back in my work queue I have with my employer, I
see I have a task that is now over a year old, still unfinished, to
provide man pages for cpusets to Michael Kerrisk" <mtk-manpages@gmx.net>

So, yes, I agree this would be a "good thing".  I just haven't gotten a
round to it (http://www.quantumenterprises.co.uk/roundtuit/index.htm)
yet.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
