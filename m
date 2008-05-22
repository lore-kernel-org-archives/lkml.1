Return-Path: <linux-kernel-owner+w=401wt.eu-S932402AbYEVBI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402AbYEVBI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 21:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYEVBIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 21:08:17 -0400
Received: from saeurebad.de ([85.214.36.134]:49422 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693AbYEVBIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 21:08:16 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Jesper Juhl" <jesper.juhl@gmail.com>
Cc: "Jonathan Corbet" <corbet@lwn.net>, "Cyrill Gorcunov" <gorcunov@gmail.com>,
       rdunlap@xenotime.net, tytso@mit.edu, hch@infradead.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       davem@davemloft.net, "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard indentation of arguments)
References: <9a8748490805211306l50b8411ax4462be18c94ca065@mail.gmail.com>
	<32279.1211401651@vena.lwn.net>
	<9a8748490805211337q1e7ceab7i80e4820c46f8171b@mail.gmail.com>
	<9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
Date: Thu, 22 May 2008 03:07:48 +0200
In-Reply-To: <9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
	(Jesper Juhl's message of "Thu, 22 May 2008 01:46:28 +0200")
Message-ID: <87d4nf2ljv.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

"Jesper Juhl" <jesper.juhl@gmail.com> writes:

> 2. How to find things to work on as a beginner
> ---
>
> Many people new to kernel development have a hard time finding
> projects to start out with. The kernel is a large project and it's not
> surprising that some people find it hard to work out where to begin.
>
> A good way to start is by trying to fix some bugs.
>
> There are plenty of bugs to go around and fixing bugs is a great way
> to learn since you need to understand (and thus learn) the code
> surrounding the bug in order to fix it properly, so it usually teaches
> a lot.  Submitting small bug fixes is also a great way to get
> comfortable with the patch submission process.
>
> Finding bugs to fix is easy. Here are some ways to find useful work to
> do:
>
  - Run a recent development kernel.  If you already know an area that
    might interest you, use the tree of that subsystem.  Otherwise
    Linus' tree.  Or the -mm tree.

> - Build a bunch of 'randconfig' kernels and log the output from the
> build. Building some 10-20 randconfig kernels usually exposes plenty
> of warnings and/or errors during the build. Fixing some of those
> should keep you busy for a while.
>
> - Grep the kernel source for "FIXME", "XXX" and similar comments. They
> often describe areas of the code that has known bugs, could be
> optimized, needs review etc. Lots of work to do can be found that way.
>
> - Look through the Kernel Janitors TODO list
> (http://kernelnewbies.org/KernelJanitors/Todo) for items of interest,
> then try to fix some of the issues on the list.
>
> - Go through the kernel Bugzilla (http://bugzilla.kernel.org/) and see
> if you can fix any of the many bugs filed in it. There's a metric
> butload of bugs filed in there that need attention.

  - Read the mailing list.  Again, if you are interested in a specific
    area, there are also subsystem-related mailing lists, check
    http://vger.kernel.org/vger-lists.html.

Probably needs some rephrasing...

	Hannes
