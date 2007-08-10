Return-Path: <linux-kernel-owner+w=401wt.eu-S937382AbXHJQZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937382AbXHJQZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 12:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932772AbXHJQYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 12:24:55 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:34121 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765177AbXHJQYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 12:24:53 -0400
Subject: Re: [PATCH] Fix typo in arch/i386/kernel/tsc.c
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
In-Reply-To: <20070809190340.26757a64.akpm@linux-foundation.org>
References: <1186711089.6899.29.camel@josh-work.beaverton.ibm.com>
	 <20070809190340.26757a64.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 10 Aug 2007 09:25:30 -0700
Message-Id: <1186763130.2713.2.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 19:03 -0700, Andrew Morton wrote:
> On Thu, 09 Aug 2007 18:58:09 -0700 Josh Triplett <josht@linux.vnet.ibm.com> wrote:
> 
> > - *  We can use khz divisor instead of mhz to keep a better percision, since
> > + *  We can use khz divisor instead of mhz to keep a better precision, since
> 
> I have an arbitrary i-dont-do-typos policy (unless they're in a printk or
> in documentation).  trivial@kernel.org is the home for patches such as this,
> please.

Sorry about that; I had intended to CC trivial as well, but apparently
didn't.  Resent to trivial.

- Josh Triplett


