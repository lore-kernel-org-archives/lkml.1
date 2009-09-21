Return-Path: <linux-kernel-owner+w=401wt.eu-S1752724AbZIUSC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724AbZIUSC7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 14:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZIUSC6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 14:02:58 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:40899 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbZIUSC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 14:02:57 -0400
Date: Mon, 21 Sep 2009 14:03:01 -0400
To: michal.simek@petalogix.com
Cc: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Subject: Re: [PATCH] Actually show KiB rather than pages in "Freeing initrd
	memory:" message on microblaze.
Message-ID: <20090921180301.GA23700@csclub.uwaterloo.ca>
References: <20090915165037.GA23702@csclub.uwaterloo.ca> <20090917154623.GD23702@csclub.uwaterloo.ca> <20090917154706.GE23702@csclub.uwaterloo.ca> <4AB773F6.7090901@petalogix.com> <20090921133203.GZ23700@csclub.uwaterloo.ca> <4AB7AAF9.3070805@petalogix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB7AAF9.3070805@petalogix.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 06:34:01PM +0200, Michal Simek wrote:
> I want to have "microblaze:" at the beginning of email/commit message.
> It is much clear for mailing list, Linus and me.

Hmm, OK.  That makes some sense.  I hadn't ever noticed that being
a trend.

-- 
Len Sorensen
