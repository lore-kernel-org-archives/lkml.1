Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbYKSIOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbYKSIOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbYKSIO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:14:26 -0500
Received: from h4.dl5rb.org.uk ([81.2.74.4]:46462 "EHLO
	ditditdahdahdah-dahdahdahditdit.dl5rb.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751308AbYKSIOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:14:25 -0500
Date: Wed, 19 Nov 2008 08:13:59 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: linux-m68k.git
Message-ID: <20081119081359.GB794@linux-mips.org>
References: <Pine.LNX.4.64.0811182136060.27671@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0811182136060.27671@anakin>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2008 at 09:49:01PM +0100, Geert Uytterhoeven wrote:

> (Finally) I created an experimental git tree for Linux/m68k:
> http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git
> 
> It contains more or less all patches I had in my quilt series at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-m68k-patches-2.6/
> A notable exception is m68k-PRIVATE-m68k-changes.diff, which hardcoded ARCH to
> m68k.
> 
> As suggested by David Woodhouse, I grouped the commits by topic. But unlike
> David's suggestion, I used topic branches, not topic repositories. Oh well,
> we'll see...

That's easy enough to undo if the need should arise.

> I also created for-next and for-linus branches. Do they look OK?
> 
> If I did something wrong, please let me know.
> This is still experimental stuff, which may be rebased if needed.
> 
> In addition, one day I may pull from Ralf's repository that reflects the state
> of Linux/m68k CVS a few commits before our server died...

It's CVS that must die, not the poor server ;-)  If you're actually going
to pull the old CVS stuff into the new git repository and you happen to have
a newer snapshot than the one which I've converted I can re-run my converter.

  Ralf
