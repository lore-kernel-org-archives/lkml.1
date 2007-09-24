Return-Path: <linux-kernel-owner+w=401wt.eu-S1761448AbXIXS3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761448AbXIXS3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 14:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbXIXS30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 14:29:26 -0400
Received: from ns.suse.de ([195.135.220.2]:47001 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753655AbXIXS3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 14:29:25 -0400
Date: Mon, 24 Sep 2007 11:32:47 -0700
From: Greg KH <gregkh@suse.de>
To: Simon Arlott <simon@fire.lp0.eu>
Cc: Duncan Sands <duncan.sands@math.u-psud.fr>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] cxacru: Cleanup code by removing "ret = ret;"
	assignments
Message-ID: <20070924183247.GA13796@suse.de>
References: <46F68708.6070409@simon.arlott.org.uk> <46F687E8.3010101@simon.arlott.org.uk> <200709231820.33086.duncan.sands@math.u-psud.fr> <46F6B215.3050500@simon.arlott.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F6B215.3050500@simon.arlott.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 23, 2007 at 07:36:05PM +0100, Simon Arlott wrote:
> On 23/09/07 17:20, Duncan Sands wrote:
> > On Sunday 23 September 2007 17:36:08 Simon Arlott wrote:
> >> Cleanup code by removing "ret = ret;" assignments.
> >> 
> >> Signed-Off-By: Simon Arlott <simon@fire.lp0.eu>
> > 
> > Acked-by: Duncan Sands <baldrick@free.fr>
> 
> Nacked-by: Simon Arlott <simon@fire.lp0.eu>
> 
> I'm only going to create a merge conflict with myself with this :|
> It'll be included with 1/3 shortly.

Ok, I'm totally confused :)

Can you resend the patches you want to have included here, that are
acked by both you and Duncan?

thanks,

greg k-h
