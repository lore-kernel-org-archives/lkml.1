Return-Path: <linux-kernel-owner+w=401wt.eu-S1759169AbYDVWYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759169AbYDVWYg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 18:24:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754835AbYDVWYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 18:24:25 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42219 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbYDVWYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 18:24:24 -0400
Date: Tue, 22 Apr 2008 15:30:16 -0700
From: Greg KH <greg@kroah.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Philipp Zabel <philipp.zabel@gmail.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Linus' tree build breakage
Message-ID: <20080422223016.GD7792@kroah.com>
References: <20080422103111.e1d38371.sfr@canb.auug.org.au> <20080422073622.GB22955@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422073622.GB22955@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 08:36:22AM +0100, Russell King wrote:
> On Tue, Apr 22, 2008 at 10:31:11AM +1000, Stephen Rothwell wrote:
> > Russell, this is why I would have liked you to participate in the
> > linux-next tree ...
> 
> linux-next will not give me anything which -mm isn't giving me.  As I
> said in the discussion, linux-next value is _very_ small for me.

But it would help all of the rest of us out immensely.  From what I can
tell (please correct me if I'm wrong), the linux-arm tree isn't
publicly seen by anyone else so they know exactly what they need to
rebase off of to submit patches for to you.  Getting your stuff into
linux-next would provide a public place for others to base off of,
making it easier for them to send patches to you ensuring that they
apply properly.

Which in the end, will help others be able to contribute easier, and
help you by getting patches you do not need to rebase yourself.

thanks,

greg k-h
