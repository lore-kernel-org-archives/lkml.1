Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbXJZEe0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbXJZEe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 00:34:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbXJZEeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 00:34:19 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:43720 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750875AbXJZEeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 00:34:18 -0400
Date: Thu, 25 Oct 2007 21:34:15 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: clameter@sgi.com, akpm@linux-foundation.org, ak@suse.de,
       Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] cpusets: add interleave_over_allowed option
Message-Id: <20071025213415.e08d85d5.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.9999.0710252049590.18868@chino.kir.corp.google.com>
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
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> I think that documenting the change in the man page as saying that
> "the nodemask will include all allowed nodes if the mems_allowed
> of a memory_spread_user cpuset is expanded" is better.

Ok.  I'm inclined the other way, but not certain enough of my
position to push the point any further.

Good enough.

> I've got a few fixes for my patchset queued so I'll resend it later

Ok.  Good work - thanks.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
