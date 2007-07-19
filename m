Return-Path: <linux-kernel-owner+w=401wt.eu-S933074AbXGSVXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933074AbXGSVXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 17:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761988AbXGSVWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 17:22:55 -0400
Received: from hq.tensilica.com ([65.205.227.29]:56454 "EHLO
	maia.hq.tensilica.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761215AbXGSVWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 17:22:55 -0400
X-Greylist: delayed 757 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jul 2007 17:22:54 EDT
Message-ID: <469FD333.9050306@tensilica.com>
Date: Thu, 19 Jul 2007 14:10:11 -0700
From: Chris Zankel <zankel@tensilica.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Chris Zankel <czankel@tensilica.com>, torvalds@linux-foundation.org,
       chris@zankel.net, linux-kernel <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: [PATCH] fix modpost warnings for xtensa
References: <200707191837.l6JIbuE25527@corvus.hq.tensilica.com> <20070719140005.863f7ffa.akpm@linux-foundation.org>
In-Reply-To: <20070719140005.863f7ffa.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Andrew Morton wrote:
> This generates unfixable-by-me rejects against Sam's git-kbuild tree.
> Sam already had a pull request into Linus for that tree.  Could I ask
> that you wait for that piece of dust to settle and then regenerate the
> diff?

Thanks Andrew. I will wait for his updates.

-Chris
