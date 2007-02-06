Return-Path: <linux-kernel-owner+w=401wt.eu-S965412AbXBFAsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965412AbXBFAsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 19:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965413AbXBFAsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 19:48:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52546
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S965411AbXBFAsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 19:48:13 -0500
Date: Mon, 05 Feb 2007 16:48:12 -0800 (PST)
Message-Id: <20070205.164812.28787904.davem@davemloft.net>
To: scot.mckinley@oracle.com
Cc: torvalds@linux-foundation.org, bert.hubert@netherlabs.nl,
       davidel@xmailserver.org, mingo@elte.hu, zach.brown@oracle.com,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org, suparna@in.ibm.com,
       bcrl@kvack.org
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
From: David Miller <davem@davemloft.net>
In-Reply-To: <45C7CB80.4040402@oracle.com>
References: <20070205213618.GA30923@outpost.ds9a.nl>
	<Pine.LNX.4.64.0702051350010.8424@woody.linux-foundation.org>
	<45C7CB80.4040402@oracle.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Scot McKinley <scot.mckinley@oracle.com>
Date: Mon, 05 Feb 2007 16:27:44 -0800

> As Joel mentioned earlier, from an Oracle perspective, one of the key 
> things we are looking for is a nice clean *common* wait point.

How much investigation have the Oracle folks (besides Zach :-) done
into Evgeniy's kevent interfaces and how much feedback have they given
to him.

I know it sounds like I'm being a pain in the ass, but it saddens
me that there is this whole large body of work implemented to solve
a problem, the maintainer keeps posting patch sets and the whole
discussions has gone silent.

I'd be quiet if there were some well formulated objections to his work
being posted, but people are posting nothing.  So either it's a
perfect API or people aren't giving it the attention and consideration
it deserves.
