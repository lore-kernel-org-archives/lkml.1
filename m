Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbXKIBaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbXKIBaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 20:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754564AbXKIBa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 20:30:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57727 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbXKIBa1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 20:30:27 -0500
Message-ID: <4733A6A6.5000605@redhat.com>
Date: Thu, 08 Nov 2007 19:15:34 -0500
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: ciol <ciol13@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
References: <fgtfqa$h9j$1@ger.gmane.org> <47331CA2.9000403@redhat.com> <fgvs7p$j0d$1@ger.gmane.org>
In-Reply-To: <fgvs7p$j0d$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ciol wrote:
> Chris Snook wrote:
> 
>> Why are you asking the developers?  We do this for the sake of the users.
> 
> 
> The kernel is the software of the developers.

The kernel is a technology.  A distribution is a product.  When decisions about 
technology and decisions about products are made *entirely* by the same people, 
the result is never good.

> It's important to know how they want it to be distributed.

For commercial distributions, the answer is: "In whichever way results in the 
largest paycheck with the least amount of stress and effort", which means doing 
it the way that's best for the customer.

Non-commercial distributions have less of this pressure, but the same principle 
applies if they care about their users.  If you're not interested in the users 
but you are interested in the technology, you should be doing your work 
upstream, so the distribution is irrelevant.

Don't get me wrong, I think stable kernel trees like 2.6.16 are a good thing. 
They serve very well a whole bunch of different niches where users are willing 
to sacrifice the support benefits of a distribution kernel for the control of an 
upstream kernel, while maintaining the stability of their installed base.  These 
users have little interest in the general-purpose distribution kernel anyway, 
aside from perhaps wishing it included some config or patch that its maintainers 
have elected not to include.

	-- Chris
