Return-Path: <linux-kernel-owner+w=401wt.eu-S1759573AbYDUVm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759573AbYDUVm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758089AbYDUVmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:42:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50588
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756545AbYDUVmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:42:04 -0400
Date: Mon, 21 Apr 2008 14:42:06 -0700 (PDT)
Message-Id: <20080421.144206.35342340.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [bug] build failures, git trees
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080421092648.943a871b.randy.dunlap@oracle.com>
References: <20080421082254.GA2522@elte.hu>
	<20080421.015837.35795810.davem@davemloft.net>
	<20080421092648.943a871b.randy.dunlap@oracle.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Mon, 21 Apr 2008 09:26:48 -0700

> On Mon, 21 Apr 2008 01:58:37 -0700 (PDT) David Miller wrote:
> 
> <deletia>
> 
> > If you really cared, you would run your randconfig system on, for
> > example, the linux-next and -mm trees, which I've specifically
> > suggested and you've specifically ignored.  And there is no
> > coincidence to that.
> 
> I do randconfigs on -mm and linux-next.  I report most* of the
> build problems ... and as far as I can tell, they are mostly
> ignored (especially in linux-next).

If you reported them against networking, I can ensure you that I did
work to correct them.  And if I didn't it was an oversight.

So at least in that context, don't feel as if such efforts are wasted.

Thanks Randy.

