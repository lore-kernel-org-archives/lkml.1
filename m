Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZJZUGH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZJZUGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 16:06:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755717AbZJZUGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 16:06:06 -0400
Received: from mail.perches.com ([173.55.12.10]:1071 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbZJZUGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 16:06:06 -0400
Subject: Re: [PATCH 1/4] strip: move driver to staging
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Greg KH <gregkh@suse.de>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20091026192026.GI2792@tuxdriver.com>
References: <1256015830-12700-1-git-send-email-linville@tuxdriver.com>
	 <20091023161006.GA1580@ucw.cz> <20091026165518.GE2792@tuxdriver.com>
	 <20091026172434.GI25725@elf.ucw.cz> <20091026184818.GB21591@suse.de>
	 <1256584063.1865.118.camel@Joe-Laptop.home>
	 <20091026192026.GI2792@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 26 Oct 2009 13:06:09 -0700
Message-ID: <1256587569.1865.135.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(forgot the reply-all)

On Mon, 2009-10-26 at 15:20 -0400, John W. Linville wrote:
> On Mon, Oct 26, 2009 at 12:07:43PM -0700, Joe Perches wrote:
> > I think adding a requirement that files have maintainers before
> > being added to not-staging is not a good thing.
> This is not a blanket policy.  Please don't imply that it is.

I believe it's an unnecessary precedent.

> > It is likely that strip could have be deleted without anyone caring.
> 
> Perhaps so...how would that be better?  It would be less work for Greg,
> but he seems to be fine with this...

It's fine by me if it moves to staging.
It's fine by me if it simply disappears as well.
It's fine by me if Greg works all he wants.

