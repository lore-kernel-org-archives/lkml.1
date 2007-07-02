Return-Path: <linux-kernel-owner+w=401wt.eu-S1756812AbXGBVJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756812AbXGBVJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 17:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755314AbXGBVJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 17:09:29 -0400
Received: from web36606.mail.mud.yahoo.com ([209.191.85.23]:28313 "HELO
	web36606.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755207AbXGBVJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 17:09:27 -0400
X-YMail-OSG: JN5b8Y4VM1n2QYr95SLQZ8AJlF0BmoQiBxdKIR2j91uEuS9Iwi.mJk29vnosHKX0SE2Gyh.A8g--
X-RocketYMMF: rancidfat
Date: Mon, 2 Jul 2007 14:09:26 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [AppArmor 00/44] AppArmor security module overview
To: Christoph Hellwig <hch@infradead.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Johansen <jjohansen@suse.de>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20070702201534.GA4896@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <104157.2649.qm@web36606.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jul 02, 2007 at 12:31:49PM -0700, Casey Schaufler wrote:
> > It's true that the code review for AppArmor has proven difficult.
> > That's going to be true of any change to the vfs layer, for any
> > reason. Have someone who was there tell you about the original XFS
> > proposals some time. Again, it's not LSM's fault.
> 
> Utterly wrong comparism.  There haven't been any VFS changes for XFS.

Ah, I suggested the original proposal, not what actually got in.
Two very different things. The XFS developers listened to the initial
feedback and, after picking themselves up off the floor, got up and
adjusted their plans.

> There has been some new functionality in the core kernel, but the
> more interesting bits where in the VM (e.g. vmap which is now widely
> used).
> 
> AA on the other hand just fucks up VFS layering to implement really dumb
> semantics.
> 
> A better comparism would be to some of the original reiser4 suggestions,
> although to be as bad you'd have to look at Hans' whitepapers and not
> actually existing code.  And yes, there's a reason his pipedreams never
> got anywhere near merged.

Agreed that the further up you want to mess things the tougher the
task you have ahead of you. That's what I was hoping to get across,
but it looks as if you have better, more recent examples than what
I offered.

Thank you.


Casey Schaufler
casey@schaufler-ca.com
