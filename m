Return-Path: <linux-kernel-owner+w=401wt.eu-S1753114Ab0ALCGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab0ALCGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752591Ab0ALCGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:06:14 -0500
Received: from ozlabs.org ([203.10.76.45]:51340 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751912Ab0ALCGN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:06:13 -0500
Date: Tue, 12 Jan 2010 13:04:50 +1100
From: Anton Blanchard <anton@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       David Rientjes <rientjes@google.com>
Subject: Re: [patch 0/6] cpumask_of_node() should handle -1 as a node
Message-ID: <20100112020450.GD12666@kryten>
References: <20100106045509.245662398@samba.org>
 <20100111141136.0ee352b3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100111141136.0ee352b3.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

> So..  what's happening here?  Nobody has applied the patches anywhere,
> you later said "the scheduler oopses in a number of places with
> CPUMASK_OFFSTACK and sparse node ids" and mention of a -stable backport
> was mentioned.

Just checked and it's already upstream on ia64. That just leaves alpha.

Anton
