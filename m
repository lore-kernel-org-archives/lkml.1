Return-Path: <linux-kernel-owner+w=401wt.eu-S1752996AbZINKPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbZINKPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 06:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZINKPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 06:15:11 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43692 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbZINKPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 06:15:10 -0400
Date: Mon, 14 Sep 2009 11:14:53 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mikael Pettersson <mikpe@it.uu.se>, James Morris <jmorris@namei.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: linux-next: manual merge of the security-testing tree with the
	arm tree
Message-ID: <20090914101452.GA696@flint.arm.linux.org.uk>
References: <20090903154700.2d4538cf.sfr@canb.auug.org.au> <20090914130355.ff26d669.sfr@canb.auug.org.au> <20090914081220.GA14204@flint.arm.linux.org.uk> <20090914185500.fc9cf713.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090914185500.fc9cf713.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 06:55:00PM +1000, Stephen Rothwell wrote:
> Actually Linus is probably clever enough to fix the conflict himself -
> after all, I did :-)

In my experience, sending follow-up emails to Linus on issues to do with
pull requests doesn't work - the pull happens long before Linus reads the
follow-up email.  It's entirely possible that Linus has already pulled
my tree, but hasn't published it yet - I've seen that happen several
times when I submit pull requests over a weekend.

If there's a problem, Linus will reply, possibly with a "check my
conflict resolution" or "I've not pulled, please fix it up your tree".

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
