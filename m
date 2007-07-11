Return-Path: <linux-kernel-owner+w=401wt.eu-S1760921AbXGKFMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760921AbXGKFMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 01:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755683AbXGKFMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 01:12:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46205
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753105AbXGKFMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 01:12:05 -0400
Date: Tue, 10 Jul 2007 22:12:24 -0700 (PDT)
Message-Id: <20070710.221224.48800386.davem@davemloft.net>
To: miklos@szeredi.hu
Cc: netdev@vger.kernel.org, ebiederm@xmission.com, akpm@linux-foundation.org,
       viro@ftp.linux.org.uk, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] rewrite AF_UNIX garbage collector, fixes race
From: David Miller <davem@davemloft.net>
In-Reply-To: <E1I61UT-0006Gk-00@dorka.pomaz.szeredi.hu>
References: <E1I61UT-0006Gk-00@dorka.pomaz.szeredi.hu>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Just to make it clear Miklos.

I have seen your patch as has everyone else.

But myself, nor any other developers, are going to review your work
any faster if you do things like try to slip things in behind the
maintainer's back as you attempted to do yesterday by asking Andrew to
put your AF_UNIX garbage collector rewrite directly into his -mm tree.

If you read the netdev list, you'll see that I do not lose important
postings often if at all, and it is frequently the case that you will
in fact see me here replying to postings made weeks if not months ago.
You just need to be patient, ok?

I run my todo list in a prioritized way, and you need patience instead
of annoying me and others over and over about your patch.

Thanks in advance for your patience and understanding.
