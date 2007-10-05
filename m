Return-Path: <linux-kernel-owner+w=401wt.eu-S1764334AbXJEXja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764334AbXJEXja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 19:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbXJEXjW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 19:39:22 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:51738 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752095AbXJEXjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 19:39:22 -0400
Date: Fri, 5 Oct 2007 16:39:18 -0700
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nickpiggin@yahoo.com.au, randy.dunlap@oracle.com, menage@google.com,
       linux-kernel@vger.kernel.org, dino@in.ibm.com, cpw@sgi.com,
       mingo@elte.hu
Subject: Re: [PATCH] cpuset and sched domains: sched_load_balance flag fixes
Message-Id: <20071005163918.46d40fed.pj@sgi.com>
In-Reply-To: <20071005161305.af27f452.akpm@linux-foundation.org>
References: <20071003114401.32194.73464.sendpatchset@jackhammer.engr.sgi.com>
	<20071005161305.af27f452.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> I'm getting 100% rejects from this - probably whatever patch it is
> patching got lost or unrecognisably mangled.

Yup - so far as I can tell, you didn't pick up the base patch that
this current patch fixes.  So, no, I wouldn't expect this patch to
make any sense.

As I stated in this current patch in the diffstat section after the
'---' marker, this current patch applies to the base patch of Subject:

  [PATCH] cpuset and sched domains: sched_load_balance flag

You probably didn't pick up that base patch because Nick and I are
still haggling over it.  Well ... we've agreed, but I can't get the
scheduler to work as I thought Nick wanted, and I'm still waiting
to hear from Nick again.

==> So yeah - throw this current patch out.

Nick ... you there ?

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
