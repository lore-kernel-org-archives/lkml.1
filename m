Return-Path: <linux-kernel-owner+w=401wt.eu-S1755475AbYGDUoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbYGDUoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbYGDUn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:43:56 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45640 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbYGDUnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:43:55 -0400
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Woodhouse <dwmw2@infradead.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: David Miller <davem@davemloft.net>, jeff@garzik.org, andi@firstfloor.org,
       tytso@mit.edu, hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
In-Reply-To: <20080704134208.6c712031@infradead.org>
References: <1215177044.10393.743.camel@pmac.infradead.org>
	 <486E2260.5050503@garzik.org>
	 <1215178035.10393.763.camel@pmac.infradead.org>
	 <20080704.133721.98729739.davem@davemloft.net>
	 <20080704134208.6c712031@infradead.org>
Content-Type: text/plain
Date: Fri, 04 Jul 2008 21:43:38 +0100
Message-Id: <1215204218.3189.8.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-07-04 at 13:42 -0700, Arjan van de Ven wrote:
> On Fri, 04 Jul 2008 13:37:21 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > It seems your employer is telling you to work on this in order to sort
> > out some perceived legal issue.  And that's the only reason you're
> > investing any effort into this.
> 
> I assume you meant Davids previous employer (Red Hat) with this, not
> his current one (Intel). I seriously doubt (and know for sure we never
> asked/told David anything around this) that Intel cares about what
> happens in tg3.

He must do. After all, I was working for Red Hat when I started on
cleaning up these drivers.

-- 
dwmw2

