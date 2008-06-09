Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbYFIS41@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbYFIS41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 14:56:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753469AbYFIS4T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 14:56:19 -0400
Received: from styx.suse.cz ([82.119.242.94]:56019 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753378AbYFIS4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 14:56:18 -0400
Subject: Re: [stable] Missing patch from stable [3/7]
From: Miklos Szeredi <mszeredi@suse.cz>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Willy Tarreau <w@1wt.eu>, Christoph Hellwig <hch@infradead.org>,
       stable@kernel.org, Michael Halcrow <mhalcrow@us.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080609171253.GI30402@sequoia.sous-sol.org>
References: <20080608085923.GC6439@1wt.eu> <1212923462.4020.224.camel@tucsk>
	 <20080608122920.GA10491@1wt.eu> <1212936622.4020.236.camel@tucsk>
	 <20080609171253.GI30402@sequoia.sous-sol.org>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 20:56:16 +0200
Message-Id: <1213037776.4020.274.camel@tucsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-06-09 at 10:12 -0700, Chris Wright wrote:
> * Miklos Szeredi (mszeredi@suse.cz) wrote:
> > On Sun, 2008-06-08 at 14:29 +0200, Willy Tarreau wrote:
> > > Well, you know the implications of leaving these known bugs open more than
> > > me. If you think some of them are really not needed, I'm fine with this,
> > > but some definitely fix real bugs (judging by the code and the comments).
> > 
> > Yeah.  Perhaps there should also be a rule, that -stable patches for
> > EXPERIMENTAL stuff (like ecryptfs) are automatically rejected.  And then
> > they wouldn't increase the workload for the people collecting/reviewing
> > the stable series.
> 
> Both users and distros enable code marked EXPERIMENTAL.  It's not
> that uncommon for code to get stuck in EXPERIMENTAL long after it's in
> general use.

OK, it's been voted down.

While I do think that -stable updates for experimental stuff are not as
important as for mainstream stuff, it's also true that it does little
harm to include these fixes.

The only harm is that lots of these non-critical patches drown out the
really important ones, which get less attention this way.

Oh, well...

Miklos


