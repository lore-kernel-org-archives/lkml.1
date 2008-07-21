Return-Path: <linux-kernel-owner+w=401wt.eu-S1755418AbYGUH2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbYGUH2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 03:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752456AbYGUH2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 03:28:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37330 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbYGUH2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 03:28:04 -0400
Date: Mon, 21 Jul 2008 03:28:01 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kevin Winchester <kjwinchester@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       "Fred ." <eldmannen@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Please add ZFS support (from GPL sources)
Message-ID: <20080721072801.GA6115@infradead.org>
References: <f188924b0807171213q43f10b09j47b34674fc8aaa38@mail.gmail.com> <487FA143.9010109@garzik.org> <20080720105724.GA8921@infradead.org> <d1af83620807200535s6516e3b7wd16233391e5e8533@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1af83620807200535s6516e3b7wd16233391e5e8533@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 20, 2008 at 09:35:45AM -0300, Kevin Winchester wrote:
> If Fred declines, is anyone free to take you up on the offer?  I have
> no filesystem experience and almost no experience with kernel code in
> general, so I would not be anyone's first choice for a task like this.
>  However, since it mainly appears to be an integration exercise (using
> the code from GRUB and making it work in linux), it might well be
> doable for me.  As a bonus, being highly inexperienced, I have no
> expectations of doing anything correctly, and thus would not react
> badly to lots of criticism.
> 
> So to summarize - if anyone else would like to undertake this work,
> they probably should.  But if no one has the time/will, then I would
> be happy to give it a try.

Yes, this offer is of course up to everyone interested.  But it's not
purely an integration effort in the traditional sense, the grub
filesystem interface is quite different from the Linux one, and the code
structure and style is quite different.  But if you're willing to learn
it should be very interesting.
