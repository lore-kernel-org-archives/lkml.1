Return-Path: <linux-kernel-owner+w=401wt.eu-S1754723AbYEZJOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723AbYEZJOI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 05:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbYEZJN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 05:13:58 -0400
Received: from relay.2ka.mipt.ru ([194.85.82.65]:47137 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbYEZJN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 05:13:57 -0400
Date: Mon, 26 May 2008 13:13:50 +0400
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Cache coherency, transactions, parallels.
Message-ID: <20080526091350.GA22703@2ka.mipt.ru>
References: <20080525134055.GA30630@2ka.mipt.ru> <483A0F3B.9060709@garzik.org> <20080526062204.GA16366@2ka.mipt.ru> <483A59D7.7020306@garzik.org> <20080526070708.GB16366@2ka.mipt.ru> <483A667F.7070707@garzik.org> <20080526074424.GA555@2ka.mipt.ru> <483A6BFB.1080209@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483A6BFB.1080209@garzik.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2008 at 03:51:23AM -0400, Jeff Garzik (jeff@garzik.org) wrote:
> 	cd /home/s0mbre/archive/pohmelfs
> 	GIT_DIR=pohmelfs.git git-update-server-info
> 
> or
> 
> 	cd /home/s0mbre/archive/pohmelfs/pohmelfs.git
> 	GIT_DIR=. git-update-server-info

Excellent, I've updated server info.
Thanks!

-- 
	Evgeniy Polyakov
