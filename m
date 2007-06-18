Return-Path: <linux-kernel-owner+w=401wt.eu-S1762215AbXFRLJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762215AbXFRLJO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 07:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbXFRLI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 07:08:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34073
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752457AbXFRLI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 07:08:57 -0400
Date: Mon, 18 Jun 2007 04:09:15 -0700 (PDT)
Message-Id: <20070618.040915.35042963.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: tgraf@suug.ch, akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race in AF_UNIX
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070618.040253.129088293.davem@davemloft.net>
References: <20070618.035144.64026005.davem@davemloft.net>
	<E1I0EtI-0007Ma-00@dorka.pomaz.szeredi.hu>
	<20070618.040253.129088293.davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 18 Jun 2007 04:02:53 -0700 (PDT)

> From: Miklos Szeredi <miklos@szeredi.hu>
> Date: Mon, 18 Jun 2007 12:55:24 +0200
> 
> > I'm all for fixing this gc mess that we have now.  But please don't
> > expect me to be the one who's doing it.
> 
> Don't worry, I only expect you to make the situation worse :-)

In any event, I'll try to find some time to look more at your patch.

But just like you don't want to be expected to rewrite the AF_UNIX GC
code, you can't expect me to go right to your patch right when you
want me to.

I am one human being, and I depend upon other developers to help me
out with patch review and so on.  If nobody else wants to review your
patch that doesn't work out so well for me.

Your behavior also tends to make me (and others) put your patch near
the end of the todo list rather than near the top.  Fix your attitude
and people will enjoy reviewing your patches that much more.  Reviewing
your work will become something to look forward to rather than a chore.

Thanks.
