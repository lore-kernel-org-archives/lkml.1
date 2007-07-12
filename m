Return-Path: <linux-kernel-owner+w=401wt.eu-S1762871AbXGLJ4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762871AbXGLJ4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 05:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755151AbXGLJ4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 05:56:38 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:36427 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbXGLJ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 05:56:37 -0400
To: davem@davemloft.net
CC: miklos@szeredi.hu, netdev@vger.kernel.org, ebiederm@xmission.com,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
In-reply-to: <20070711.192940.21926073.davem@davemloft.net> (message from
	David Miller on Wed, 11 Jul 2007 19:29:40 -0700 (PDT))
Subject: Re: [PATCH resend] rewrite AF_UNIX garbage collector, fixes race
References: <E1I61UT-0006Gk-00@dorka.pomaz.szeredi.hu> <20070711.192940.21926073.davem@davemloft.net>
Message-Id: <E1I8vOw-0003bO-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 12 Jul 2007 11:55:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This looks good, patch applied and I'll get this into the
> 2.6.23 merge window.
> 
> Once this sits around for a while and we feel super-confident
> with it we can consider a backport into -stable.

OK.  Thanks for the review.

Miklos
