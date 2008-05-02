Return-Path: <linux-kernel-owner+w=401wt.eu-S934243AbYEBNoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934243AbYEBNoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 09:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbYEBNoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 09:44:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:34590 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048AbYEBNoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 09:44:05 -0400
Message-ID: <481B1A9F.8010909@suse.com>
Date: Fri, 02 May 2008 09:43:59 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: reiserfs patch in the opensuse tree
References: <20080502103626.GA17183@lst.de>
In-Reply-To: <20080502103626.GA17183@lst.de>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Christoph Hellwig wrote:
> The opensuse kernel rpm has a lot of large reiserfs cleanups and
> refacorings in for almost half a year now.  Any chance you could submit
> this stuff upstream?

That's the plan. I've been spending the last few weeks splitting,
cleaning, and testing to make sure they're ready. I need to finish up
tracking down some performance regressions and I'll submit them.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkgbGp8ACgkQLPWxlyuTD7JARwCeLPQSGu1iPD7aBk0abMBTQ2l3
w1IAoJSiiQ+YrdwjdJHIL2ZQHae9HM2W
=/WQB
-----END PGP SIGNATURE-----
