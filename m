Return-Path: <linux-kernel-owner+w=401wt.eu-S1759114AbZLGIbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114AbZLGIbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759054AbZLGIbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:31:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48480 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969AbZLGIbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:31:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=B8aAZglAyfMuiTr/ni9aAnEWHAH4KahdVmyBZ2vPwddnTutrgwo+xDrt54PNEZvOTE
         8z7OJ5CEHytkMyFmIeOjBvdevxhM1x7F+jzhBuHVppnESjLt/sMGTcIc7QU/w5mCUeOi
         D94l2Qinaov624HL8iTti9k2kaUvbxlFlcjiQ=
Date: Mon, 7 Dec 2009 09:31:14 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT pull] bkl core patches for 2.6.33
Message-ID: <20091207083113.GA6279@nowhere>
References: <alpine.LFD.2.00.0912061857340.3089@localhost.localdomain> <alpine.LFD.2.00.0912061044530.3560@localhost.localdomain> <alpine.LFD.2.00.0912061948220.3089@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0912061948220.3089@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 06, 2009 at 07:49:29PM +0100, Thomas Gleixner wrote:
> On Sun, 6 Dec 2009, Linus Torvalds wrote:
> > On Sun, 6 Dec 2009, Thomas Gleixner wrote:
> > > 
> > > Please pull the latest bkl-core-for-linus git tree from:
> > 
> > Hmm. Seeing this, I wonder: has anybody kept track of the reiserfs bkl 
> > removal?
> 
> Yes, Frederic has his own git tree for that, which I reviewed and
> monitored. Frederic, what's the latest status ?
> 
> Thanks,
> 
> 	tglx



I'm preparing the pull request :)

