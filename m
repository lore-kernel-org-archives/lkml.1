Return-Path: <linux-kernel-owner+w=401wt.eu-S1759944AbYEYUVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944AbYEYUVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 16:21:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbYEYUVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 16:21:30 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:33292 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbYEYUV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 16:21:29 -0400
Date: Mon, 26 May 2008 00:21:22 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Cache coherency, transactions, parallels.
Message-ID: <20080525202121.GA8017@2ka.mipt.ru>
References: <20080525134055.GA30630@2ka.mipt.ru> <4839C414.3070504@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4839C414.3070504@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Sun, May 25, 2008 at 03:55:00PM -0400, Jeff Garzik (jeff@garzik.org) wrote:
> Evgeniy Polyakov wrote:
> > * Client parallel extensions: ability to write to multiple servers and
> >	balance reading between them. Code was imported to the current 
> >	version,
> >	but not enabled yet.
> > * Client dynamical server reconfiguration: ability to add/remove servers
> >	from working set by server command and from userspace.
> 
> Neat :)

Yeah :)

> >2. Source archive.
> >http://tservice.net.ru/~s0mbre/archive/pohmelfs/
> >Git tree.
> >http://tservice.net.ru/~s0mbre/archive/pohmelfs/pohmelfs.git/
> 
> Is the server available via git?
> 
> http://tservice.net.ru/~s0mbre/archive/pohmelfs/server/ does not include 
> history information, etc.

I've just cloned a git tree for the server, but do not expect intersting
stuff there, usually I make big commits which incorporate lots of stuff
in one go.

http://tservice.net.ru/~s0mbre/archive/pohmelfs/server/fserver.git/

-- 
	Evgeniy Polyakov
