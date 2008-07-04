Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbYGDUxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbYGDUxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 16:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752581AbYGDUw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 16:52:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42489
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbYGDUw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 16:52:58 -0400
Date: Fri, 04 Jul 2008 13:52:58 -0700 (PDT)
Message-Id: <20080704.135258.255741026.davem@davemloft.net>
To: dwmw2@infradead.org
Cc: arjan@infradead.org, jeff@garzik.org, andi@firstfloor.org, tytso@mit.edu,
       hugh@veritas.com, akpm@linux-foundation.org,
       kosaki.motohiro@jp.fujitsu.com, mchan@broadcom.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org
Subject: Re: [bug?] tg3: Failed to load firmware "tigon/tg3_tso.bin"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1215204218.3189.8.camel@shinybook.infradead.org>
References: <20080704.133721.98729739.davem@davemloft.net>
	<20080704134208.6c712031@infradead.org>
	<1215204218.3189.8.camel@shinybook.infradead.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>
Date: Fri, 04 Jul 2008 21:43:38 +0100

> He must do. After all, I was working for Red Hat when I started on
> cleaning up these drivers.

Then I hope you've caught the e100 ucode in your changes, for
the sake of full transparency :-)
