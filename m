Return-Path: <linux-kernel-owner+w=401wt.eu-S1759972AbYGQPLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759972AbYGQPLS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 11:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753044AbYGQPLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 11:11:08 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:37471 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334AbYGQPLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 11:11:05 -0400
Date: Thu, 17 Jul 2008 09:11:01 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: petkovbb@gmail.com
Cc: benh@kernel.crashing.org, Paul Mundt <lethal@linux-sh.org>,
       jrigby@freescale.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH] Fix collateral damage to top level Makefile
Message-ID: <20080717151101.GE31932@secretlab.ca>
References: <20080717070549.30755.13083.stgit@trillian.secretlab.ca> <20080717072731.GB12273@linux-sh.org> <1216284624.7740.326.camel@pasglop> <9ea470500807170249h5fc7ce46q3c2ef7473a22b0ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ea470500807170249h5fc7ce46q3c2ef7473a22b0ba@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 11:49:30AM +0200, Boris Petkov wrote:
> On Thu, Jul 17, 2008 at 10:50 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Thu, 2008-07-17 at 16:27 +0900, Paul Mundt wrote:
> >> On Thu, Jul 17, 2008 at 01:06:55AM -0600, Grant Likely wrote:
> > Well, it's partially my fault for not spotting it when pulling in
> > Grant's git and pushing out to Linus.
> >
> > Anyway, it's a mistake, shit happens, I doubt Grant will do that one
> > twice :-)
> 
> Oh come on, don't scare the guy more than he is - now he'll be staring
> frantically at each +-diff line before submitting :). And it's not like it's the
> end of the world, it's just that Fred has turned 42 or similar :)
> 
> P.S. If I only knew how such an innocent thing would destroy a man's
> life i never would've
> reported it in the first place :). Sorry Grant.

Heh, oh please, I've got a thicker skin that that.  I appreciate the
error being pointed out.

But Ben's right.  That mistake will not happen again!  :-)

Cheers,
g.
