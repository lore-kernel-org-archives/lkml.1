Return-Path: <linux-kernel-owner+w=401wt.eu-S1764547AbXHWOXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764547AbXHWOXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 10:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764206AbXHWOXC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 10:23:02 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:51588 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764155AbXHWOXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 10:23:00 -0400
Date: Thu, 23 Aug 2007 16:24:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Andy Whitcroft <apw@shadowen.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-rc3-mm1
Message-ID: <20070823142419.GA30531@uranus.ravnborg.org>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org> <46CC6FB2.1010801@csn.ul.ie> <20070822111029.46db0ab7.akpm@linux-foundation.org> <20070823120318.GA7506@shadowen.org> <20070823122825.GA29724@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070823122825.GA29724@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2007 at 02:28:25PM +0200, Sam Ravnborg wrote:
> 
> Something like this then:
> [PATCH] x86_64: fix preferred-stack-boundary check

OK - Andi decided to do this in a bit more invasive way but it looks OK.
So disregard my patch.

	Sam
