Return-Path: <linux-kernel-owner+w=401wt.eu-S1752857AbXDWIFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbXDWIFM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752885AbXDWIFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:05:12 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:42474 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752868AbXDWIFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:05:03 -0400
Date: Mon, 23 Apr 2007 01:04:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: William Heimbigner <icxcnika@mar.tar.cc>
Cc: Rik van Riel <riel@redhat.com>, Eric Hopper <hopper@omnifarious.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Question about Reiser4
Message-Id: <20070423010445.454eda63.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704230640540.25153@server.thyself>
References: <20070423020046.GA28477@omnifarious.org>
	<462C2E5B.1080008@redhat.com>
	<Pine.LNX.4.64.0704230353000.25153@server.thyself>
	<462C4858.3050006@redhat.com>
	<Pine.LNX.4.64.0704230555020.25153@server.thyself>
	<462C4D32.4000909@redhat.com>
	<Pine.LNX.4.64.0704230611430.25153@server.thyself>
	<462C5034.9090403@redhat.com>
	<Pine.LNX.4.64.0704230640540.25153@server.thyself>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 06:42:24 +0000 (GMT) William Heimbigner <icxcnika@mar.tar.cc> wrote:

> 
> On Mon, 23 Apr 2007, Rik van Riel wrote:
> > William Heimbigner wrote:
> >
> >>  If there was 1) a maintainer and 2) code that didn't break "coding
> >>  standards", would it be included in the kernel?
> >
> > While I cannot speak for Linus and Andrew, code that fulfills
> > these criteria (and is useful to have - reiser4 seems to have
> > enough user interest) usually gets accepted.
> >
> > http://kernelnewbies.org/UpstreamMerge has some hints.
> 
> So in conclusion / to answer Eric's question,
> 1) reiser4 needs a maintainer
> 2) reiser4 needs the code quality cleaned up
> 3) Until those two things happen, it's extremely unlikely that it will be 
> included in the kernel.
> 

The namesys engineers continue to maintain reiser4 and I continue to
receive patches for it.

Right now I'd say that the main blockages for reiser4 are a) the developers
aren't presently asking for inclusion (afaik) and b) lack of reviewing
effort from other kernel developers.  
