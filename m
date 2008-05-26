Return-Path: <linux-kernel-owner+w=401wt.eu-S1754363AbYEZHHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754363AbYEZHHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 03:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823AbYEZHHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 03:07:24 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:56517 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbYEZHHX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 03:07:23 -0400
Date: Mon, 26 May 2008 11:07:09 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Cache coherency, transactions, parallels.
Message-ID: <20080526070708.GB16366@2ka.mipt.ru>
References: <20080525134055.GA30630@2ka.mipt.ru> <483A0F3B.9060709@garzik.org> <20080526062204.GA16366@2ka.mipt.ru> <483A59D7.7020306@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483A59D7.7020306@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 02:33:59AM -0400, Jeff Garzik (jeff@garzik.org) wrote:
> >No it should be cc4d281eb8d9a4d3a5610acf1558c327358f5725
> >Author: Evgeniy Polyakov johnpol@2ka.mipt.ru <zbr@gavana.yandex.ru>
> >Date:   Sun May 25 17:24:56 2008 +0400
> >
> >    Kconfig entries for cc group and debugging.
> >    
> >I used 'git push remote_repo' to push data after repository was create, 
> >probably I
> >should use 'git push --all remote_repo', please try again.
> 
> Nope.
> 
> Did you forget git-update-server-info, since your method is HTTP?

At least on server HEAD (refs/heads/master) points to
cc4d281eb8d9a4d3a5610acf1558c327358f5725

I tries git-update-server-info on client and pushed all again, but it
returned that everything is up-to-date.

-- 
	Evgeniy Polyakov
