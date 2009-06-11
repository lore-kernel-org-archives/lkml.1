Return-Path: <linux-kernel-owner+w=401wt.eu-S1756764AbZFKSeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbZFKSeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 14:34:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755074AbZFKSdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 14:33:54 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:48594 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754534AbZFKSdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 14:33:54 -0400
Date: Thu, 11 Jun 2009 14:33:56 -0400
From: William Thompson <wt@electro-mechanical.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, ath5k-devel <ath5k-devel@venema.h4ckr.net>
Subject: Re: 3com 3crxjk10075 with ath5k driver
Message-ID: <20090611183356.GH19203@electro-mechanical.com>
References: <20090609195100.GY19203@electro-mechanical.com> <b6c5339f0906091339j3784c36bxe888af16272fbcde@mail.gmail.com> <20090610112357.GB19203@electro-mechanical.com> <20090610113406.GE19635@hash.localnet> <20090610115432.GC19203@electro-mechanical.com> <20090610120736.GF19635@hash.localnet> <20090611152502.GG19203@electro-mechanical.com> <b6c5339f0906111041u2cc55324w7b5c2523abbe2def@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c5339f0906111041u2cc55324w7b5c2523abbe2def@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 11, 2009 at 01:41:30PM -0400, Bob Copeland wrote:
> On Thu, Jun 11, 2009 at 11:25 AM, William
> Thompson<wt@electro-mechanical.com> wrote:
> > On Wed, Jun 10, 2009 at 08:07:36AM -0400, Bob Copeland wrote:
> >> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> >>
> >
> > That's huge! ?Isn't there an easier way to do it?
> 
> Unfortunately, it depends on surrounding rfkill framework that hit the tree
> after 2.6.30.  Now that compat-wireless builds, you can try it, but since it
> is a backport, YMMV.

Isn't there an easy way to obtain the patch?  THe clone has completed but I
don't have a clue what to do.
