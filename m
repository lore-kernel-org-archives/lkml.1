Return-Path: <linux-kernel-owner+w=401wt.eu-S1763883AbZE0SwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763883AbZE0SwZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 14:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758407AbZE0SwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 14:52:18 -0400
Received: from www.sr71.net ([198.145.64.142]:43728 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757914AbZE0SwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 14:52:18 -0400
Subject: Re: [PATCH 18/38] C/R: core stuff
From: Dave Hansen <dave@sr71.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com
In-Reply-To: <20090526193503.GB11909@x200.localdomain>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
	 <1242968132-1044-18-git-send-email-adobriyan@gmail.com>
	 <20090526131644.GA20920@hallyn.com>
	 <20090526193503.GB11909@x200.localdomain>
Content-Type: text/plain
Date: Wed, 27 May 2009 11:52:17 -0700
Message-Id: <1243450337.8071.155.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 23:35 +0400, Alexey Dobriyan wrote:
> The other part, is that I looked at Oren patchset, found quite a lot of
> suspicious, broken and unclean places and decided that it'd be faster
> to start from scratch because sending patches will overhaul like 85% of
> the code.

I know the feeling.  I get sudden urges to rewrite the whole patch set,
but I'm working on getting past them too. :)

As long as we have two patch sets, *nobody* is going to get their
patches in, that's virtually guaranteed.  Just look at the poor I/O
controller.

The OpenVZ users are almost certainly the most important container and
c/r users out there today.  Meeting their needs with whatever we come up
with should be a top priority and I know I'm counting on you to help us
do that.

But, I'm having a really hard time culling the OpenVZ user needs from
your patch set.  If we really need to rewrite 85% of Oren's stuff to
meet the OpenVZ needs, then by all means let's do it.  I'm even willing
to help you.  But, I honestly don't know what you need.

Can we talk about specifics?

-- Dave

