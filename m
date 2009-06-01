Return-Path: <linux-kernel-owner+w=401wt.eu-S1752542AbZFAVc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbZFAVc7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 17:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751175AbZFAVcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 17:32:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45199
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819AbZFAVcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 17:32:48 -0400
Date: Mon, 01 Jun 2009 14:32:48 -0700 (PDT)
Message-Id: <20090601.143248.258478440.davem@davemloft.net>
To: marcel@holtmann.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT]: Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1243867942.3015.18.camel@localhost.localdomain>
References: <20090601.032500.54712490.davem@davemloft.net>
	<1243867942.3015.18.camel@localhost.localdomain>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Marcel Holtmann <marcel@holtmann.org>
Date: Mon, 01 Jun 2009 16:52:21 +0200

>> Things are really winding down, and the bug fix rate is down
>> to at best a trickle.  It might be time to do that final
>> release soon :-)
> 
> can you give me quick update on this pull request:
> 
> 	http://marc.info/?l=linux-netdev&m=124341070008320&w=2

Sorry that I overlooked this.

Unfortunately, I almost entirely use patchwork to manage my
work queue.  So if you're pull request doesn't attach a patch
it's possible that it'll get lost in my inbox.  So I suggest
attaching a patch to your pull requests, at least for bug
fix work, just like John Linville does for wireless.

That also let's me quickly review your work in-place in my
mailbox before I even type the git pull command, which helps
me a lot.

Anyways, I've pulled in your tree, thanks.
