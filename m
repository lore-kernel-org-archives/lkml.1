Return-Path: <linux-kernel-owner+w=401wt.eu-S1762389AbYG1VTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762389AbYG1VTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 17:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761424AbYG1VPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 17:15:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:49479 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761045AbYG1VPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 17:15:04 -0400
Subject: Re: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.1.10.0807280838580.3486@nehalem.linux-foundation.org>
References: <1217239117.11188.187.camel@pasglop>
	 <alpine.LFD.1.10.0807280838580.3486@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 29 Jul 2008 07:14:52 +1000
Message-Id: <1217279692.11188.213.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 08:40 -0700, Linus Torvalds wrote:
> 
> On Mon, 28 Jul 2008, Benjamin Herrenschmidt wrote:
> > 
> > It's all in:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulus/powerpc.git merge
> 
> It doesn't really seem to be. I get "Already up-to-date.", and the top 
> commit there seems to be from July 3..
> 
> Forgot to push?

No, forgot to s/paulus/benh in the path :-)
> 
> > (Hopefully no silly non-printable character this time, at least
> > nothing I manage to spot with evo but who knows...)
> 
> Yeah, no odd whitespace here either. Not that it helps ;)

Cheers,
Ben.


