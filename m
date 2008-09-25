Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYIYLmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYIYLmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 07:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYIYLmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:42:09 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40428 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbYIYLmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:42:07 -0400
Date: Thu, 25 Sep 2008 07:41:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: pull request: wireless-2.6 2008-09-24
Message-ID: <20080925114133.GA5044@tuxdriver.com>
References: <20080924231720.GD3639@tuxdriver.com> <1222321622.2510.455.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222321622.2510.455.camel@debian.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 01:47:02PM +0800, Zhu Yi wrote:
> On Wed, 2008-09-24 at 17:17 -0600, John W. Linville wrote:
> > Dave,
> > 
> > One more for 2.6.27 -- a fix for a possible interrupt storm.  There is
> > even a link in the commit log to a youtube video of the storm in
> > progress. :-)
> > 
> > Let me know if there are problems!
> 
> Can you also add this one? It doesn't panic the kernel when a frame from
> firmware is invalid.
> 
> http://marc.info/?l=linux-wireless&m=122219037706528&w=2

Is there an open bug report for that anywhere?  Is this something
that real users (no offense to Johannes) are likely to hit?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
