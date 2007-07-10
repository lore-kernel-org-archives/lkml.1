Return-Path: <linux-kernel-owner+w=401wt.eu-S1762926AbXGJRyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762926AbXGJRyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 13:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758105AbXGJRyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 13:54:15 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42305
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757332AbXGJRyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 13:54:14 -0400
Date: Tue, 10 Jul 2007 10:54:36 -0700 (PDT)
Message-Id: <20070710.105436.71090052.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH re-resend] fix race in AF_UNIX garbage collector
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I8CMY-00053l-00@dorka.pomaz.szeredi.hu>
References: <E1I8CMY-00053l-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 10 Jul 2007 11:50:30 +0200

> Can you please add this to -mm.  Sometimes that has wonderful effect
> on the willingness of people to look at a patch.

No, I will merge this into my networking tree when I get the
chance to review your patch and it will automatically get into
-mm that way.

Please stop trying to rush this situation, it's driving me absolutely
bananas, and you're serving to tick me off rather than make me want to
review and go over your work.

You do this continuously, and it hurts rather than helps your cause,
so please cut it out.
