Return-Path: <linux-kernel-owner+w=401wt.eu-S1758653AbXGKGv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653AbXGKGv3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753047AbXGKGvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:51:19 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53955
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751218AbXGKGvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:51:19 -0400
Date: Tue, 10 Jul 2007 23:51:42 -0700 (PDT)
Message-Id: <20070710.235142.92583640.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] rewrite AF_UNIX garbage collector, fixes race
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I8VtC-0007uM-00@dorka.pomaz.szeredi.hu>
References: <20070710.221224.48800386.davem@davemloft.net>
	<20070710222511.bcc87825.akpm@linux-foundation.org>
	<E1I8VtC-0007uM-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jul 2007 08:41:30 +0200

> This may seem low priority and irrelevant, but it _is_ a bug, and it's
> affecting a real world application.  So please take that into
> consideration.

I'm not the only person who hasn't reviewed your latest patch yet.

You may want to consider that this might have something to do with
your attitude and behavior, rather than the importance of your patch.
