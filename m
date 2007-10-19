Return-Path: <linux-kernel-owner+w=401wt.eu-S966708AbXJSJHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966708AbXJSJHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 05:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965782AbXJSJHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 05:07:33 -0400
Received: from twin.jikos.cz ([213.151.79.26]:46833 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965767AbXJSJHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 05:07:32 -0400
Date: Fri, 19 Oct 2007 11:07:16 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, ak@suse.de
Subject: PIE randomization (was Re: 2.6.23-mm1)
In-Reply-To: <20071017213312.60475b86.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0710191105540.18815@twin.jikos.cz>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
 <20071017160101.4dde7223.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0710171108090.18815@twin.jikos.cz>
 <20071017183626.70bdd13e.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0710171340580.18815@twin.jikos.cz>
 <20071017213312.60475b86.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, KAMEZAWA Hiroyuki wrote:

> > yes, this looks correct to me. Did you verify that it makes the 
> > problem you are seeing go away?
> yes. I confirmed this works well.

Thanks a lot, it works flawlessly. I will rebase the patch after 
2.6.24-rc1 is released and will send it to Andrew's queue, hopefully for 
2.6.25.

Thanks!

-- 
Jiri Kosina
