Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbYLCMiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbYLCMiD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYLCMhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:37:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52909 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbYLCMhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:37:50 -0500
Date: Wed, 3 Dec 2008 07:37:47 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: New location for generic headers?
Message-ID: <20081203123747.GA1751@infradead.org>
References: <20081203003620.GA32069@basil.nowhere.org> <200812031140.02338.arnd@arndb.de> <20081203120110.GA2822@uranus.ravnborg.org> <20081203121955.GJ6703@one.firstfloor.org> <20081203122149.GA27944@infradead.org> <20081203124218.GK6703@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203124218.GK6703@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 01:42:18PM +0100, Andi Kleen wrote:
> On Wed, Dec 03, 2008 at 07:21:49AM -0500, Christoph Hellwig wrote:
> > On Wed, Dec 03, 2008 at 01:19:55PM +0100, Andi Kleen wrote:
> > > The only problem I see is that it would user space use of asm/ 
> > > without make headers_install impossible.
> > 
> > Well, they aren't supposed to do that anyway, so I would consider
> > breaking it a good idea.
> 
> Sorry, but working against your users is never a good strategy.

It's not working against users.  It's just preventing something that
is a very bad thing already. 

