Return-Path: <linux-kernel-owner+w=401wt.eu-S1751003AbXDIQi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751003AbXDIQi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 12:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbXDIQi2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 12:38:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbXDIQi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 12:38:27 -0400
Message-ID: <461A6679.7000206@redhat.com>
Date: Mon, 09 Apr 2007 12:14:49 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Chris Wright <chrisw@sous-sol.org>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.20.6
References: <20070406202948.GU10574@sequoia.sous-sol.org>
In-Reply-To: <20070406202948.GU10574@sequoia.sous-sol.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wright wrote:
> We (the -stable team) are announcing the release of the 2.6.20.6 kernel.
> This has 2 important fixes that should have been in 2.6.20.5.  They are
> issues that were pointed with 2.6.20.5 patches during its review cycle,
> but the patch updates were mistakenly dropped.  Please accept our
> apologies for the mistake.
> 
> The diffstat and short summary of the fixes are below.
> 
> I'll also be replying to this message with a copy of the patch between
> 2.6.20.5 and 2.6.20.6.
> 
> The updated 2.6.20.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.20.y.git
> and can be browsed at the normal kernel.org git web browser:
>         www.kernel.org/git/
> 

That tree is not up-to-date. So much for using it to track -stable --
what should I use instead?

