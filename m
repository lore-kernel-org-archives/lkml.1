Return-Path: <linux-kernel-owner+w=401wt.eu-S1754564AbYEaQXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbYEaQXj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752921AbYEaQX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:23:29 -0400
Received: from vps1.tull.net ([66.180.172.116]:48376 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752798AbYEaQX3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:23:29 -0400
X-Spam-Check-By: mail.local.tull.net
Date: Sun, 1 Jun 2008 02:23:13 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Cyrill Gorcunov <gorcunov@gmail.com>,
       rdunlap@xenotime.net, tytso@mit.edu, hch@infradead.org,
       viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: CFD: linux-wanking@vger.kernel.org (was [PATCH] Standard	indentation of arguments)
Message-ID: <20080531162312.GA5599@tull.net>
References: <9a8748490805211306l50b8411ax4462be18c94ca065@mail.gmail.com> <32279.1211401651@vena.lwn.net> <9a8748490805211337q1e7ceab7i80e4820c46f8171b@mail.gmail.com> <9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a8748490805211646s5ef93f8ey43ebbc7746fb1a3b@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggestions ...

On Thu, May 22, 2008 at 01:46:28AM +0200, Jesper Juhl wrote:
> Ok, here's a first (very) rough draft of a KernelNewbieGuide document.
> It can certainly be expanded a lot and my grammar and spelling is far
> from perfect, but hey, it's a first rough draft :)

[...]

> - Go through the kernel Bugzilla (http://bugzilla.kernel.org/) and see
> if you can fix any of the many bugs filed in it. There's a metric
> butload of bugs filed in there that need attention.

"buttload"

> As far as tools go, all you really need are the tools compile the
> kernel (gcc, make etc) and a text editor to edit the source - vi,
> emacs, joe, almost anything will do fine.

"tools _to_ compile the kernel"

> Developing against anything older than the latest stable kernel is
> likely to be a waste of effort due to the rapid pace of
> development. Once you finish your patch against a several months (or
> even weeks) old kernel, your patch runs a great risk of being obsolete
> or impossible to apply (this greatly depends on the area you work on
> ofcours cince some areas change more rapidly than others, but do try

"of course, since"

> If your patch did not get applied and you recieved an ACK or some

"received"

> criticism about your patch, then your job is easy. If there's a very
> explicit rejection of the patch by the maintainer of the code with a
> good reason, then don't bother sending it again, it probably will
> never be applied. If the patch received improvement suggestions or
> other review comments, then you should create a new version of your
> patch that adresses the feedback you get and then re-submit (it's
> usually a good idea to list what stuff you've adressed when
> re-submitting).

"addressed".

I'd probably make a few grammatical changes too. When you're happy
with the content and your document is in the tree, I'll submit a
patch :-)

Nick.
-- 
PGP Key ID = 0x418487E7                      http://www.nick-andrew.net/
PGP Key fingerprint = B3ED 6894 8E49 1770 C24A  67E3 6266 6EB9 4184 87E7
