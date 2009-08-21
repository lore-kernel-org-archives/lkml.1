Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZHUMew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZHUMew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 08:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754610AbZHUMev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 08:34:51 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:51516 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103AbZHUMev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 08:34:51 -0400
Subject: Re: linux-next: noot failure for next-20090820
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org
In-Reply-To: <20090821135617.8b255a5a.sfr@canb.auug.org.au>
References: <20090821094226.286faa67.sfr@canb.auug.org.au>
	 <1250821846.6514.23.camel@heimdal.trondhjem.org>
	 <20090821024454.GA8786@fieldses.org>
	 <20090821135617.8b255a5a.sfr@canb.auug.org.au>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 08:34:46 -0400
Message-Id: <1250858086.6514.35.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 5 msgs/h 1 sum rcpts/h 8 sum msgs/h 1 total rcpts 1149 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: D9F40D66144B9962BF6CE90138221A2763A16B60
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 159 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-21 at 13:56 +1000, Stephen Rothwell wrote:
> Hi Trond,
> 
> On Thu, 20 Aug 2009 22:44:54 -0400 "J. Bruce Fields" <bfields@fieldses.org> wrote:
> >
> > > Could both you and Bruce check if the following patch fixes the problem?
> > 
> > Yep, that boots for me, thanks.
> 
> Works for me as well.  I will add it at the end of linux-next today and
> hope to see it in your tree tomorrow.
> 
> Thanks.

Thanks to you both for testing. The fix is now in my tree.

Cheers
  Trond

