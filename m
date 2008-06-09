Return-Path: <linux-kernel-owner+w=401wt.eu-S1756747AbYFIRTE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747AbYFIRTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 13:19:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753077AbYFIRSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 13:18:54 -0400
Received: from sous-sol.org ([216.99.217.87]:46256 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715AbYFIRSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 13:18:53 -0400
Date: Mon, 9 Jun 2008 10:12:53 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Willy Tarreau <w@1wt.eu>, Christoph Hellwig <hch@infradead.org>,
       stable@kernel.org, Michael Halcrow <mhalcrow@us.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] Missing patch from stable [3/7]
Message-ID: <20080609171253.GI30402@sequoia.sous-sol.org>
References: <20080608085923.GC6439@1wt.eu> <1212923462.4020.224.camel@tucsk> <20080608122920.GA10491@1wt.eu> <1212936622.4020.236.camel@tucsk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212936622.4020.236.camel@tucsk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Miklos Szeredi (mszeredi@suse.cz) wrote:
> On Sun, 2008-06-08 at 14:29 +0200, Willy Tarreau wrote:
> > Well, you know the implications of leaving these known bugs open more than
> > me. If you think some of them are really not needed, I'm fine with this,
> > but some definitely fix real bugs (judging by the code and the comments).
> 
> Yeah.  Perhaps there should also be a rule, that -stable patches for
> EXPERIMENTAL stuff (like ecryptfs) are automatically rejected.  And then
> they wouldn't increase the workload for the people collecting/reviewing
> the stable series.

Both users and distros enable code marked EXPERIMENTAL.  It's not
that uncommon for code to get stuck in EXPERIMENTAL long after it's in
general use.

thanks,
-chris
