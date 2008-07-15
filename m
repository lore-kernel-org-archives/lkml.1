Return-Path: <linux-kernel-owner+w=401wt.eu-S1760950AbYGOBbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760950AbYGOBbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 21:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756506AbYGOBbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 21:31:16 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53248
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754616AbYGOBbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 21:31:15 -0400
Date: Mon, 14 Jul 2008 18:31:16 -0700 (PDT)
Message-Id: <20080714.183116.121978835.davem@davemloft.net>
To: mpatocka@redhat.com
Cc: andi@firstfloor.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com
Subject: Re: [SUGGESTION]: drop virtual merge accounting in I/O requests
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0807141903001.2825@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0807141000340.24718@devserv.devel.redhat.com>
	<20080714.143751.266098047.davem@davemloft.net>
	<Pine.LNX.4.64.0807141903001.2825@devserv.devel.redhat.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikulas Patocka <mpatocka@redhat.com>
Date: Mon, 14 Jul 2008 19:16:17 -0400 (EDT)

> So the question is: to reduce number of requests by 12% on an outdated 
> SCSI card, it is sensible to maintain complicated merge accounting logic 
> in the core block layer? To me, it doesn't seem sensible.

Rip out the code if you like, then.  I really don't have time to
work on this myself.  So if you do, by all means do whatever
you think is appropriate.

