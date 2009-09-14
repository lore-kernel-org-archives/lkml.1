Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbZINMrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbZINMrl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 08:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbZINMrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 08:47:39 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:55906 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422AbZINMrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 08:47:39 -0400
Date: Mon, 14 Sep 2009 21:47:42 +0900 (JST)
Message-Id: <20090914.214742.115912456.ryov@valinux.co.jp>
To: dm-devel@redhat.com, snitzer@redhat.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, corsetproject@googlegroups.com,
       ioband-devel@lists.sourceforge.net,
       virtualization@lists.linux-foundation.org, kunai@linux-foundation.jp,
       osonoi@linux-foundation.jp
Subject: Re: [dm-devel] Re: IO controller Mini-Summit 2009
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090914021509.GB4070@redhat.com>
References: <20090826.203251.260094379.ryov@valinux.co.jp>
	<20090914021509.GB4070@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

Mike Snitzer <snitzer@redhat.com> wrote:
> On Wed, Aug 26 2009 at  7:32am -0400,
> Ryo Tsuruta <ryov@valinux.co.jp> wrote:
> 
> > Hi All,
> > 
> > As I have notified before, The 1st Linux IO controller Mini-Summit
> > will be held in Tokyo Japan on Oct 17 -- day before the 9th Linux
> > kernel summit. So I would like to propose the following topics for 
> > the mini-summit and discuss about them.
> > 
> > - Multiple IO controller development projects
> >   - There are two activities for the development of IO controller,
> >     Vivek's io-controller and dm-ioband. Do we have to pick one of
> >     them to put into the mainline? How to advance the development?
> 
> This has been said by others before but: there is no reason the above
> line of discussion can't happen on LKML et. al. (preferably now).
> Deferring the discussion until Oct 17 guarantees that no solution would
> be merged into 2.6.32.  This would be quite unfortunate considering how
> far Vivek's IO Controller has come.   Aren't there also doubts about
> whether the appropriate upstream people will be able to attend this
> mini-summit?

I don't mean to defer the discussion until the mini-summit. I would
like to discuss about the above topic anytime in mailing lists and
hear opinions from the upstream people.

Thanks,
Ryo Tsuruta
