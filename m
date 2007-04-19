Return-Path: <linux-kernel-owner+w=401wt.eu-S1767018AbXDSUOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767018AbXDSUOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767023AbXDSUOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:14:46 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58455
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1767018AbXDSUOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:14:45 -0400
Date: Thu, 19 Apr 2007 13:14:48 -0700 (PDT)
Message-Id: <20070419.131448.71554303.davem@davemloft.net>
To: dhowells@redhat.com
Cc: ebiederm@xmission.com, akpm@osdl.org, containers@lists.osdl.org,
       oleg@tv-sign.ru, hch@infradead.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: Getting the new RxRPC patches upstream
From: David Miller <davem@davemloft.net>
In-Reply-To: <2969.1176992303@redhat.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<29341.1176975158@redhat.com>
	<2969.1176992303@redhat.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Thu, 19 Apr 2007 15:18:23 +0100

> Eric W. Biederman <ebiederm@xmission.com> wrote:
> 
> > What is the ETA on your patches?
> 
> That depends on Dave Miller now, I think.  I'm assuming they need to go
> through the network GIT tree to get to Linus.  Certainly Andrew Morton seems
> to think so.

I applied already the patches I thought were appropriate,
you had some crypto layer changes that you need to work
out with Herbert Xu before the rest can be applied.

Let me know what the status is of that stuff.

Either way, I don't think it should block Eric's work here.
If his stuff is more ready first, it should go in and then
you have a little bit of patch merging to do that's all.

