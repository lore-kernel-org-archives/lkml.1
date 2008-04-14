Return-Path: <linux-kernel-owner+w=401wt.eu-S1761358AbYDNXwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358AbYDNXwU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 19:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYDNXwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 19:52:12 -0400
Received: from bc.sympatico.ca ([209.226.175.184]:53293 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197AbYDNXwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 19:52:11 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al0FAMKKA0hMQWoK/2dsb2JhbACBXql0
Date: Mon, 14 Apr 2008 19:52:08 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Adrian Bunk <bunk@stusta.de>, Christoph Hellwig <hch@infradead.org>,
       akpm@osdl.org
Subject: Re: [patch 12/17] Immediate Values - Kconfig menu in EMBEDDED
	(updated)
Message-ID: <20080414235208.GB19596@Krystal>
References: <20080409150829.855195878@polymtl.ca> <200804101323.56697.rusty@rustcorp.com.au> <20080410193226.GA22894@Krystal> <200804110754.10706.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200804110754.10706.rusty@rustcorp.com.au>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:52:00 up 45 days, 20:02,  5 users,  load average: 0.24, 0.59,
	0.70
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rusty Russell (rusty@rustcorp.com.au) wrote:
> On Friday 11 April 2008 05:32:26 Mathieu Desnoyers wrote:
> > +	  It consumes slightly more memory and requires to modify the
> > +	  instruction stream each time a variable is updated.
> 
> Sorry, I missed this grammar bug last time.  Also, probable don't want to 
> scare someone that we're changing instructions on every var change :)
> 
> 	It consumes slightly more memory and modifies the instruction
> 	stream each time any specially-marked variable is updated.
> 

Will update, thanks!

> Thanks,
> Rusty.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
