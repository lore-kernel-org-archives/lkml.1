Return-Path: <linux-kernel-owner+w=401wt.eu-S1756700AbZFJLyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700AbZFJLyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 07:54:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbZFJLya
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 07:54:30 -0400
Received: from mail.electro-mechanical.com ([216.184.71.30]:38946 "EHLO
	mail.electro-mechanical.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753069AbZFJLya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 07:54:30 -0400
Date: Wed, 10 Jun 2009 07:54:32 -0400
From: William Thompson <wt@electro-mechanical.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-kernel@vger.kernel.org, ath5k-devel <ath5k-devel@venema.h4ckr.net>
Subject: Re: 3com 3crxjk10075 with ath5k driver
Message-ID: <20090610115432.GC19203@electro-mechanical.com>
References: <20090609195100.GY19203@electro-mechanical.com> <b6c5339f0906091339j3784c36bxe888af16272fbcde@mail.gmail.com> <20090610112357.GB19203@electro-mechanical.com> <20090610113406.GE19635@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610113406.GE19635@hash.localnet>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 07:34:06AM -0400, Bob Copeland wrote:
> On Wed, Jun 10, 2009 at 07:23:57AM -0400, William Thompson wrote:
> > > I suppose it could be asserting something on rfkill gpios; ath5k hasn't had
> > > real rfkill support yet.  Anyone else know about these devices?
> > 
> > It's possible.  The LED on it goes off when it's pushed in.  Which reminds
> > me, I don't think the ath5k driver allows the LED to blink when it's
> > transmitting/receiving, it just stays on.
> 
> Can you try latest wireless-testing?  There's an rfkill patch for
> ath5k in it.  URL is:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git

Unfortunately, I don't know how to use git.

> As for LEDs, there's a patch in kernel bugzilla.  I don't have a link handy
> but you can check the ath5k-devel archives from a week or two ago, let
> me know if you can't find it.

I'll see.
