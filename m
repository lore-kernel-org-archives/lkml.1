Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850Ab0BJUUq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 15:20:46 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42534 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323Ab0BJUUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 15:20:44 -0500
Date: Wed, 10 Feb 2010 15:19:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mb@bu3sch.de
Subject: Re: pull request: wireless-2.6 2010-02-10
Message-ID: <20100210201953.GC3286@tuxdriver.com>
References: <20100210185816.GB3286@tuxdriver.com> <20100210.110756.201335073.davem@davemloft.net> <1265829337.19075.0.camel@jlt3.sipsolutions.net> <20100210.113658.137273026.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210.113658.137273026.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 11:36:58AM -0800, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Wed, 10 Feb 2010 20:15:37 +0100
> 
> > It was intentional -- that sdev doesn't even have an irq member, but
> > nobody ever noticed because of the wrong ifdef.
> 
> Ok, then this needs to be explained in the commit message.

OK...mind if I just revert the current version and ask Michael to
resubmit with an appropriate changelog entry?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
