Return-Path: <linux-kernel-owner+w=401wt.eu-S1753799AbYFRKVH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799AbYFRKVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 06:21:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYFRKU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 06:20:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57680 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbYFRKUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 06:20:54 -0400
Date: Wed, 18 Jun 2008 19:20:20 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [Bad page] trying to free locked page? (Re: [PATCH][RFC] fix kernel BUG at mm/migrate.c:719! in 2.6.26-rc5-mm3)
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org
In-Reply-To: <20080618113235.c89ec08d.nishimura@mxp.nes.nec.co.jp>
References: <20080618003334.DE2A.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080618113235.c89ec08d.nishimura@mxp.nes.nec.co.jp>
Message-Id: <20080618191814.37BC.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > I got bad_page after hundreds times of page migration.
> > > It seems that a locked page is being freed.
> > 
> > I can't reproduce this bad page.
> > I'll try again tomorrow ;)
> 
> OK. I'll report on my test more precisely.

Thank you verbose explain.
I ran its testcase >3H today.
but unfortunately, I couldn't reproduce it.

Hmm...


