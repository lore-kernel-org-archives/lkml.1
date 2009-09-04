Return-Path: <linux-kernel-owner+w=401wt.eu-S1756766AbZIDMbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766AbZIDMbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 08:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755862AbZIDMbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 08:31:43 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:50488 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753612AbZIDMbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 08:31:42 -0400
Subject: Re: VM issue causing high CPU loads
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Simon Kirby <sim@hostway.ca>
Cc: Yohan <ytordjman@corp.free.fr>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       Neil Brown <neilb@suse.de>, "J. Bruce Fields" <bfields@fieldses.org>,
       mikevs@xs4all.net
In-Reply-To: <20090903222253.GA8405@hostway.ca>
References: <4A92A25A.4050608@yohan.staff.proxad.net>
	 <20090824162155.ce323f08.akpm@linux-foundation.org>
	 <4A96463E.5080002@corp.free.fr> <4A9C34F8.2010307@corp.free.fr>
	 <20090902170642.f4381c1d.akpm@linux-foundation.org>
	 <1251982884.18338.9.camel@heimdal.trondhjem.org>
	 <4A9FC719.9020104@corp.free.fr>
	 <1251986526.18338.29.camel@heimdal.trondhjem.org>
	 <20090903200550.GB5257@hostway.ca>
	 <1252010965.18338.63.camel@heimdal.trondhjem.org>
	 <20090903222253.GA8405@hostway.ca>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 08:31:37 -0400
Message-Id: <1252067497.13204.3.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 14 sum msgs/h 1 total rcpts 1328 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 8461A7DCF4F53C7C9533B3C64BDB33AFEA24FB48
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 218 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 15:22 -0700, Simon Kirby wrote:
> So, for environments with all POSIX systems, what do you think about
> perhaps a mount or export flag that violates the spec on purpose to allow
> numeric IDs to be used?

No! I'm not interested in starting a LinuxPrivateNFSv4 protocol on top
of everything else we've got...

Trond

