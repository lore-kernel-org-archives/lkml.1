Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbYEANGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbYEANGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:06:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754093AbYEANGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:06:43 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39345 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761260AbYEANGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:06:39 -0400
Date: Wed, 30 Apr 2008 08:06:28 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Willy Tarreau <w@1wt.eu>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080430080628.34e5183b@infradead.org>
In-Reply-To: <200805011441.07286.rjw@sisk.pl>
References: <20080429.190352.137408408.davem@davemloft.net>
	<200805011338.34735.rjw@sisk.pl>
	<20080430072822.4d931a3c@infradead.org>
	<200805011441.07286.rjw@sisk.pl>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 14:41:05 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> 
> The testing is not really a part of the process right now, though.
> We somehow hope that the kernel will be tested sufficiently before a
> major release, but we don't measure the testing coverage, for
> example.

Well. Take 2.6.25.. we know Fedora shipped it in their alpha's and
betas (and in rawhide). Those are used by a lot of people; so for me
that's a whole bunch of coverage right there. Is it perfect? No.
But in a way it's in the spirit of open source: the people who care
about a stable release the most (distros) [1], helped us getting this
tested. The other people on this thread we care greatly at least also
help us test in general.


[1] Not trying to say no single person wouldn't care; but a distro
tends to care more due to the sheer number of users... 
