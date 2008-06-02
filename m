Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbYFBITI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbYFBITI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbYFBISy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:18:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:56322 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754551AbYFBISx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:18:53 -0400
Date: Mon, 2 Jun 2008 03:18:49 -0500
From: Paul Jackson <pj@sgi.com>
To: David Miller <davem@davemloft.net>
Cc: James.Bottomley@hansenpartnership.com, dwmw2@infradead.org,
       penberg@cs.helsinki.fi, ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
Message-Id: <20080602031849.592c23ae.pj@sgi.com>
In-Reply-To: <20080528.230934.131215087.davem@davemloft.net>
References: <1212010931.3445.103.camel@localhost.localdomain>
	<1212013125.2236.58.camel@shinybook.infradead.org>
	<1212014127.3445.115.camel@localhost.localdomain>
	<20080528.230934.131215087.davem@davemloft.net>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David wrote:
> Did Andrew Morton fixup whitespace errors when he was starting to become
> familiar with the tree?  Did I?  No, none of us did this stuff.

I came in knowing I wanted to do cpusets, and intentionally
picked off an "easier" target first -- overhauling the bitmap,
cpumask, nodemask apparatus -- in order to get up to speed.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
