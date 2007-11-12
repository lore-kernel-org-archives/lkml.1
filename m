Return-Path: <linux-kernel-owner+w=401wt.eu-S1752082AbXKLOfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbXKLOfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 09:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbXKLOfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 09:35:08 -0500
Received: from main.gmane.org ([80.91.229.2]:33695 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbXKLOfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 09:35:06 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tuomo Valkonen <tuomov@iki.fi>
Subject: Re: [poll] Is the megafreeze development model broken?
Date: Mon, 12 Nov 2007 13:51:25 +0000 (UTC)
Message-ID: <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com>
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: jolt.modeemi.cs.tut.fi
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-11-12, Eric W. Biederman <ebiederm@xmission.com> wrote:
> I think a megafreeze development model is sane.  Finding a collection
> of software versions that are all known to work together is very
> interesting, and useful.  Making it so you can deliver something that
> just works to end users is always interesting.

The distros only do that for the most important and most popular
packages, most of which have become rather "generic" and faceless
behemots in the sense that they do not have definite authors and so
on, and for which it takes years to respond to bug reports in any case
(if someone even bothers to enter the bug in registration-required
Suckzilla, Debian's reportbug becoming much more usable in this case,
even though it typically takes another year for the package maintainer
to report things back upstream, if it ever even happens).

Other more marginal software with a face, the distros just throw in
and expect the author to deal with users having problems with ancient
development snapshots and even bugs in stable versions that the distros
simply refuse to fix. They should not distribute that kind of software
at all. That is, distros should stick to providing stable base systems, 
and fully supported (and renamed if not generic) customised versions of
other software for their target audience. For the rest, there should
be better mechanisms for authors to distribute binary or otherwise
easily and reliably installable packages of their software. 

Closed-source operating systems are more decentralised than Linux,
where the par^W^W a few big distros have de facto central control 
over the software that users can conveniently install.

-- 
Tuomo

