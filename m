Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbXKMF3w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbXKMF3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 00:29:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbXKMF3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 00:29:40 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59318
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1760845AbXKMF3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 00:29:39 -0500
Date: Mon, 12 Nov 2007 21:29:39 -0800 (PST)
Message-Id: <20071112.212939.41915591.davem@davemloft.net>
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: DaveM collecting netdev patches this week
From: David Miller <davem@davemloft.net>
In-Reply-To: <4737092F.3080600@garzik.org>
References: <4737092F.3080600@garzik.org>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jeff@garzik.org>
Date: Sun, 11 Nov 2007 08:52:47 -0500

> David Miller has agreed to collect net driver bug fix patches in my 
> absence, with Stephen and Francois (and others, hopefully) helping out 
> with patch review.

I'll be integrating fixes directly into my usual net-2.6 tree at:

	kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6.git

so folks should submit fixes against that.

> David -- note that my 2.6.25 was opened a little while ago.  If you feel 
> motivated enough to collect non-bugfix patches, please make sure to 
> apply them on top of netdev-2.6.git#upstream.  There is already quite a 
> collection of stuff for 2.6.25 queued...

I've cut a tree with this 2.6.25 network device driver stuff
that people can submit against at:

	kernel.org:/pub/scm/linux/kernel/git/davem/netdev-2.6.git

Thanks.
