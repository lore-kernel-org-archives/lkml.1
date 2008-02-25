Return-Path: <linux-kernel-owner+w=401wt.eu-S1760094AbYBYX5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094AbYBYX5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 18:57:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756337AbYBYX5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 18:57:23 -0500
Received: from verein.lst.de ([213.95.11.210]:57660 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025AbYBYX5W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 18:57:22 -0500
Date: Tue, 26 Feb 2008 00:57:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: xfs-masters@oss.sgi.com
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com,
       johannes@sipsolutions.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: filesystem corruption on xfs after 2.6.25-rc1 (bisected, powerpc related?)
Message-ID: <20080225235703.GA17530@lst.de>
References: <20080225112310.GA5516@soziologie.ch> <200802260042.35918.rjw@sisk.pl> <47C353D4.1060501@sandeen.net> <200802260052.57875.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802260052.57875.rjw@sisk.pl>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 12:52:56AM +0100, Rafael J. Wysocki wrote:
> > I'm not suggesting a partial revert; I just wonder which part of the
> > change is causing the problem, as part of the debugging process.
> 
> Understood.
> 
> My point is, if that's not practical (whatever the reason), I'd consider
> reverting all of the commits in question.

If you could revert all of them and verify it makes the problem go away
that would be a very good start already.

