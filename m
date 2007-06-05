Return-Path: <linux-kernel-owner+w=401wt.eu-S933685AbXFEXUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933685AbXFEXUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765452AbXFEXTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:19:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:46012 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765435AbXFEXTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:19:52 -0400
Date: Tue, 5 Jun 2007 16:19:53 -0700
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, ak@suse.de, clameter@cthulhu.engr.sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] cpusets: do not allow TIF_MEMDIE tasks to allocate
 globally
Message-Id: <20070605161953.9c7b2c2e.pj@sgi.com>
In-Reply-To: <alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
References: <alpine.DEB.0.99.0706051537450.13200@chino.kir.corp.google.com>
	<20070605160149.348b5c4a.pj@sgi.com>
	<alpine.DEB.0.99.0706051608090.16201@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The intended purpose of TIF_MEMDIE was to allocate pages without being 

Ok then ... you probably right.  I'll stand down.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
