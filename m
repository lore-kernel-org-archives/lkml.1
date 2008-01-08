Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbYAHWt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbYAHWt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:49:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752558AbYAHWtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:49:09 -0500
Received: from ozlabs.org ([203.10.76.45]:34316 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbYAHWtH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:49:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] call sysrq_timer_list_show from a workqueue
Date: Wed, 9 Jan 2008 09:48:43 +1100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080108063113.GA21287@fattire.cabal.ca> <200801082250.06828.rusty@rustcorp.com.au> <20080108155119.GA26114@elte.hu>
In-Reply-To: <20080108155119.GA26114@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801090948.43594.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 02:51:19 Ingo Molnar wrote:
> cool :-)
>
> finally we have a _really_ sane symbols subsystem. Kudos :)

Actually, the interface is horribly scattered.  It'd be nice for someone to go 
through and look at what the minimum we actually need is and come up with a 
system to organize them.

BTW, do you want this fix in 2.6.24?
Rusty.
