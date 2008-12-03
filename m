Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbYLCMb2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbYLCMb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 07:31:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbYLCMbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 07:31:20 -0500
Received: from one.firstfloor.org ([213.235.205.2]:43176 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751337AbYLCMbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 07:31:20 -0500
Date: Wed, 3 Dec 2008 13:42:18 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Sam Ravnborg <sam@ravnborg.org>,
       Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: New location for generic headers?
Message-ID: <20081203124218.GK6703@one.firstfloor.org>
References: <20081203003620.GA32069@basil.nowhere.org> <200812031140.02338.arnd@arndb.de> <20081203120110.GA2822@uranus.ravnborg.org> <20081203121955.GJ6703@one.firstfloor.org> <20081203122149.GA27944@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203122149.GA27944@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2008 at 07:21:49AM -0500, Christoph Hellwig wrote:
> On Wed, Dec 03, 2008 at 01:19:55PM +0100, Andi Kleen wrote:
> > The only problem I see is that it would user space use of asm/ 
> > without make headers_install impossible.
> 
> Well, they aren't supposed to do that anyway, so I would consider
> breaking it a good idea.

Sorry, but working against your users is never a good strategy.

-Andi

-- 
ak@linux.intel.com
