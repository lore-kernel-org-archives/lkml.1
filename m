Return-Path: <linux-kernel-owner+w=401wt.eu-S933905AbXHJCD4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905AbXHJCD4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 22:03:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758269AbXHJCDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 22:03:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49730 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758607AbXHJCDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 22:03:49 -0400
Date: Thu, 9 Aug 2007 19:03:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, johnstul@us.ibm.com
Subject: Re: [PATCH] Fix typo in arch/i386/kernel/tsc.c
Message-Id: <20070809190340.26757a64.akpm@linux-foundation.org>
In-Reply-To: <1186711089.6899.29.camel@josh-work.beaverton.ibm.com>
References: <1186711089.6899.29.camel@josh-work.beaverton.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Aug 2007 18:58:09 -0700 Josh Triplett <josht@linux.vnet.ibm.com> wrote:

> - *  We can use khz divisor instead of mhz to keep a better percision, since
> + *  We can use khz divisor instead of mhz to keep a better precision, since

I have an arbitrary i-dont-do-typos policy (unless they're in a printk or
in documentation).  trivial@kernel.org is the home for patches such as this,
please.
