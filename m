Return-Path: <linux-kernel-owner+w=401wt.eu-S933635AbYBOKAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635AbYBOKAk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 05:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764164AbYBOKAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 05:00:25 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41491 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761838AbYBOKAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 05:00:23 -0500
Date: Fri, 15 Feb 2008 04:00:21 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, clameter@sgi.com, Lee.Schermerhorn@hp.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080215040021.31e22cf4.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802141739050.16945@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<20080214040918.d735e920.pj@sgi.com>
	<alpine.DEB.1.00.0802141135110.17096@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802141739050.16945@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> like MPOL_F_RELATIVE_NODES or whatever Paul decides to call it 

MPOL_F_RELATIVE_NODES it is.

I see no compelling need for this name to track whatever
we name the relative bitmap operator.  They are related,
but not the same thing.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
