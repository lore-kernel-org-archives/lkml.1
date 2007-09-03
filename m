Return-Path: <linux-kernel-owner+w=401wt.eu-S1754573AbXICM60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbXICM60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751523AbXICM6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:58:15 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38936 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbXICM6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:58:14 -0400
Date: Mon, 3 Sep 2007 05:57:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: hpa@zytor.com, michal.k.k.piotrowski@gmail.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mingo@elte.hu, lists4me@web.de, jeff.chua.linux@gmail.com,
       adaplas@gmail.com, lenb@kernel.org, dth@dth.net,
       linux-fsdevel@vger.kernel.org, nfs@lists.sourceforge.net,
       Trond.Myklebust@netapp.com, andrew@digital-domain.net,
       peter.kovar@gmail.com
Subject: Re: [2/4] 2.6.23-rc5: known regressions
Message-Id: <20070903055733.4220ff79.akpm@linux-foundation.org>
In-Reply-To: <20070903054602.68ddd468.akpm@linux-foundation.org>
References: <46DBD982.3080102@googlemail.com>
	<46DBDD8B.7040706@googlemail.com>
	<46DBE660.9020309@zytor.com>
	<20070903054602.68ddd468.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 3 Sep 2007 05:46:02 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:
> Apart from suspend-to-disk's a), all of the above are post-2.6.21
> regressions.

I meant: post-2.6.22 regressions.
