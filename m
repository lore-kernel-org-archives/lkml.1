Return-Path: <linux-kernel-owner+w=401wt.eu-S1758715AbZFBHyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbZFBHyW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 03:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757545AbZFBHyM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 03:54:12 -0400
Received: from senator.holtmann.net ([87.106.208.187]:39334 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbZFBHyL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 03:54:11 -0400
Subject: Re: [GIT]: Networking
From: Marcel Holtmann <marcel@holtmann.org>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090601.143248.258478440.davem@davemloft.net>
References: <20090601.032500.54712490.davem@davemloft.net>
	 <1243867942.3015.18.camel@localhost.localdomain>
	 <20090601.143248.258478440.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 02 Jun 2009 09:53:48 +0200
Message-Id: <1243929229.3192.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

> >> Things are really winding down, and the bug fix rate is down
> >> to at best a trickle.  It might be time to do that final
> >> release soon :-)
> > 
> > can you give me quick update on this pull request:
> > 
> > 	http://marc.info/?l=linux-netdev&m=124341070008320&w=2
> 
> Sorry that I overlooked this.

no problem, but I was just wondering since you normally never miss
anything on netdev ;)

> Unfortunately, I almost entirely use patchwork to manage my
> work queue.  So if you're pull request doesn't attach a patch
> it's possible that it'll get lost in my inbox.  So I suggest
> attaching a patch to your pull requests, at least for bug
> fix work, just like John Linville does for wireless.
> 
> That also let's me quickly review your work in-place in my
> mailbox before I even type the git pull command, which helps
> me a lot.
> 
> Anyways, I've pulled in your tree, thanks.

Will have to rewrite my git-sum script, but that should not be a problem
at all. Thanks for pulling.

Regards

Marcel


