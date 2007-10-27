Return-Path: <linux-kernel-owner+w=401wt.eu-S1756012AbXJ0P0f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012AbXJ0P0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 11:26:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXJ0P02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 11:26:28 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:58510 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbXJ0P01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 11:26:27 -0400
Date: Sat, 27 Oct 2007 17:28:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.23-mm1] CONFIG_LOCALVERSION handling broken
Message-ID: <20071027152801.GA31881@uranus.ravnborg.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <471142A8.40307@imap.cc> <47169593.7060901@imap.cc> <472356FC.9090302@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <472356FC.9090302@imap.cc>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 27, 2007 at 05:19:24PM +0200, Tilman Schmidt wrote:
> /me wrote:
> 
> > ts@xenon:~/kernel/linux-2.6.23-mm1-work> make include/config/kernel.release
> > ts@xenon:~/kernel/linux-2.6.23-mm1-work> cat include/config/kernel.release
> > 2.6.23-mm1-testing
> > ts@xenon:~/kernel/linux-2.6.23-mm1-work> make
> > [...]
> > ts@xenon:~/kernel/linux-2.6.23-mm1-work> cat include/config/kernel.release
> > 2.6.23-mm1
> [...]
> > I'll just skip this -mm release and wait for 2.6.24-rc1, hoping
> > it won't have the same problem.
> 
> 2.6.24-rc1 is fine, so the issue can be closed.

Thanks for reporting back,

	Sam
