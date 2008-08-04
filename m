Return-Path: <linux-kernel-owner+w=401wt.eu-S1753438AbYHDMjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438AbYHDMjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 08:39:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYHDMjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 08:39:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46147 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYHDMjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 08:39:09 -0400
Subject: Re: [PATCH] Using Intel CRC32 instruction to accelerate CRC32c
	algorithm by new crypto API.
From: David Woodhouse <dwmw2@infradead.org>
To: Austin Zhang <austin_zhang@linux.intel.com>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
In-Reply-To: <1217847481.20845.37.camel@localhost.localdomain>
References: <1217842507.20845.18.camel@localhost.localdomain>
	 <1217844725.3454.580.camel@pmac.infradead.org>
	 <1217846139.20845.25.camel@localhost.localdomain>
	 <1217846726.3454.589.camel@pmac.infradead.org>
	 <1217847481.20845.37.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 04 Aug 2008 12:25:58 +0100
Message-Id: <1217849158.3454.599.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 06:58 -0400, Austin Zhang wrote:
> BTW, why did I always got each email on this thread twice:(? (the same
> email twice) 

You're probably subscribed to the linux-kernel list, and you're also
being Cc'd directly.

Normally, your filters should notice the copy which has a Return-Path:
matching 'linux-kernel-owner.*@vger.kernel.org', and put that into your
lkml folder with a few hundred other messages each day -- while the copy
which is direct will still have the original sender, and would go into
your inbox where you'll see it.

-- 
dwmw2

