Return-Path: <linux-kernel-owner+w=401wt.eu-S1758627AbXGKHGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627AbXGKHGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 03:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378AbXGKHFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 03:05:53 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41020
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751691AbXGKHFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 03:05:52 -0400
Date: Wed, 11 Jul 2007 00:06:15 -0700 (PDT)
Message-Id: <20070711.000615.78709408.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org, ebiederm@xmission.com,
       viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] rewrite AF_UNIX garbage collector, fixes race
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I8WF8-0007we-00@dorka.pomaz.szeredi.hu>
References: <E1I8VtC-0007uM-00@dorka.pomaz.szeredi.hu>
	<20070710.235142.92583640.davem@davemloft.net>
	<E1I8WF8-0007we-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 11 Jul 2007 09:04:10 +0200

> Dave, I really appreciate the work you do.  Please forgive my
> impatience.

No problem.

Your patch is first in line for me to review tomorrow ok?
