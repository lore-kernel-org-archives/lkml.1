Return-Path: <linux-kernel-owner+w=401wt.eu-S1763231AbXGJRzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763231AbXGJRzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758566AbXGJRy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:54:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39576
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756767AbXGJRy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:54:57 -0400
Date: Tue, 10 Jul 2007 10:55:20 -0700 (PDT)
Message-Id: <20070710.105520.30182869.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: miklos@szeredi.hu, netdev@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH re-resend] fix race in AF_UNIX garbage collector
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070710030443.f2deaab6.akpm@linux-foundation.org>
References: <E1I8CMY-00053l-00@dorka.pomaz.szeredi.hu>
	<20070710030443.f2deaab6.akpm@linux-foundation.org>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 10 Jul 2007 03:04:43 -0700

> On Tue, 10 Jul 2007 11:50:30 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > Can you please add this to -mm.  Sometimes that has wonderful effect
> > on the willingness of people to look at a patch.
> 
> sure ;)

Andrew please don't, it's in my "to review" pile.
