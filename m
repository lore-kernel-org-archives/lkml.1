Return-Path: <linux-kernel-owner+w=401wt.eu-S934816AbZLGJ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934816AbZLGJ2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759198AbZLGJ2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:28:18 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47362 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759280AbZLGJ2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:28:17 -0500
Date: Mon, 7 Dec 2009 10:28:22 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: linux-next: block tree build failure
Message-ID: <20091207092822.GV8742@kernel.dk>
References: <20091207194429.d33903ed.sfr@canb.auug.org.au> <20091207084903.GU8742@kernel.dk> <20091207202335.77ea4068.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091207202335.77ea4068.sfr@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07 2009, Stephen Rothwell wrote:
> Hi Jens,
> 
> On Mon, 7 Dec 2009 09:49:03 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:
> >
> > Thanks Stephen, I merged your patch and updated the branches.
> 
> I presume that you build tested as well - or do you trust me ;-)

In this case I trust you, since you say you tested it and I do consider
you a credible source :-). I did compile locally, as a santity check.
Adding a header I consider pretty low risk.

-- 
Jens Axboe

