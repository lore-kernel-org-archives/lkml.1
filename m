Return-Path: <linux-kernel-owner+w=401wt.eu-S1161464AbXDXOdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161464AbXDXOdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161775AbXDXOdU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:33:20 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:52498 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161464AbXDXOdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:33:19 -0400
Date: Tue, 24 Apr 2007 16:34:09 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Matt Ranon <mranon@javadevices.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux maillist <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE][PATCH] Kcli - Kernel command line interface.
Message-ID: <20070424143409.GA2952@uranus.ravnborg.org>
References: <617125.34935.qm@web88104.mail.re2.yahoo.com> <a781481a0704231935o5d878692p2311b834f5c6d47e@mail.gmail.com> <462DF9E0.5050707@imap.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462DF9E0.5050707@imap.cc>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2007 at 02:36:48PM +0200, Tilman Schmidt wrote:
> Satyam Sharma schrieb:
> > You might have your reasons for being so anxious to avoid any
> > userspace at all, but quoting famous words, continuing to maintain
> > Kcli out-of-tree could soon turn out to be an act for
> > self-flagellation for you :-)
> 
> OTOH, considering certain recent comments on this list[1],
> maintaining it in-tree might turn out to be not that much
> better.
> 
> SCNR
> T.
> 
> [1] <20070422172017.52f21a90@the-village.bc.nu> or http://lkml.org/lkml/2007/4/22/139
Trolling?
This is comparing apples and oranges. There is no replacemnt in the works for kcli and
the complexity of the code idffers a lot.
I would say that readability differ a lot too.

	Sam
