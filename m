Return-Path: <linux-kernel-owner+w=401wt.eu-S1758169AbXEINli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169AbXEINli (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 09:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753091AbXEINl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 09:41:27 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:38370 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758010AbXEINl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 09:41:26 -0400
Date: Wed, 9 May 2007 15:39:08 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Cc: Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: nbd problem.
Message-ID: <20070509133908.GW4163@kernel.dk>
References: <20070508194053.GA23615@bitwizard.nl> <a781481a0705081333u7b910522x5aac0a0e532d5f85@mail.gmail.com> <20070509111049.GA2362@bitwizard.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070509111049.GA2362@bitwizard.nl>
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAA==
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09 2007, Rogier Wolff wrote:
> On Tue, May 08, 2007 at 01:33:52PM -0700, Satyam Sharma wrote:
> > On 5/8/07, Rogier Wolff <R.E.Wolff@bitwizard.nl> wrote:
> > >
> > >Hi,
> > >
> > >The nbd client still reliably hangs when I use it.
> 
> Someone suggested to use 
> 
> http://git.kernel.org/?p=linux/kernel/git/axboe/linux-2.6-block.git;a=summary
> 
> and that fixed it.  (i.e. there is something in there that should
> be merged....)

Hmm, which branch? Most of my stuff is merged up with Linus as this
point.

> Jens, thanks for pointing out that there were different locks 
> involved.

You're welcome.

-- 
Jens Axboe

