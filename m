Return-Path: <linux-kernel-owner+w=401wt.eu-S1765488AbYBZWJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765488AbYBZWJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:09:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763243AbYBZWI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:08:59 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:44898 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763210AbYBZWI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:08:59 -0500
Date: Tue, 26 Feb 2008 16:08:56 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080226160856.1b10c237.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802261345060.10790@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802250012420.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250013580.12368@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802250014170.12368@chino.kir.corp.google.com>
	<20080226115627.681dafb9.pj@sgi.com>
	<alpine.DEB.1.00.0802261253510.10790@chino.kir.corp.google.com>
	<1204061567.5309.42.camel@localhost>
	<alpine.DEB.1.00.0802261345060.10790@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clearly enough, David, my sense of what makes for clear code differs
from your sense.  Not much either of us can (or would want to) do about
that.

I was reluctant to push my version of this patch publically, because I
couldn't affort do test it adequately, by my definition of adequately.

So, fortunately, you stepped up to push your version.

There's plenty enough good stuff in your version that I definitely
want to see it succeed.

So, after a little bit of spitting at each other, you will take whatever
of my suggestions make sense (though try to avoid doing things to placate
me that neither one of us actually prefer ;), and you will discard the
remainder of my suggestions.

We've done that.  Good luck with this.

Acked-by: Paul Jackson <pj@sgi.com>

I still look forward to some further improvements in the Documentation
changes.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
