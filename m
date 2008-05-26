Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYEZGW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYEZGW2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 02:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752071AbYEZGWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 02:22:17 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:36729 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbYEZGWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 02:22:17 -0400
Date: Mon, 26 May 2008 10:22:10 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Cache coherency, transactions, parallels.
Message-ID: <20080526062204.GA16366@2ka.mipt.ru>
References: <20080525134055.GA30630@2ka.mipt.ru> <483A0F3B.9060709@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483A0F3B.9060709@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 25, 2008 at 09:15:39PM -0400, Jeff Garzik (jeff@garzik.org) wrote:
> Evgeniy Polyakov wrote:
> >Git tree.
> >http://tservice.net.ru/~s0mbre/archive/pohmelfs/pohmelfs.git/
> 
> Is this really the latest commit?
> 
> commit 21549d0a101c1c9dcdb1fe8d59685415cc0a5e9a
> Author: Evgeniy Polyakov johnpol@2ka.mipt.ru <zbr@gavana.yandex.ru>
> Date:   Tue May 13 20:54:49 2008 +0400
> 
> I would have guessed modifications occurred more recently than May 13.

No it should be cc4d281eb8d9a4d3a5610acf1558c327358f5725
Author: Evgeniy Polyakov johnpol@2ka.mipt.ru <zbr@gavana.yandex.ru>
Date:   Sun May 25 17:24:56 2008 +0400

    Kconfig entries for cc group and debugging.
    
I used 'git push remote_repo' to push data after repository was create, probably I
should use 'git push --all remote_repo', please try again.

-- 
	Evgeniy Polyakov
