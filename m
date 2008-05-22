Return-Path: <linux-kernel-owner+w=401wt.eu-S936181AbYEVKJu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936181AbYEVKJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:09:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764628AbYEVKJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:09:38 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39628 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755402AbYEVKJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:09:38 -0400
Message-ID: <48354660.7060500@pobox.com>
Date: Thu, 22 May 2008 06:09:36 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] drivers/net/: remove CVS keywords
References: <20080519220619.GL17716@cs181133002.pp.htv.fi>
In-Reply-To: <20080519220619.GL17716@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch removes some CVS keywords that weren't updated for a long 
> time.
> 
> I haven't touched drivers that looked as if they might still be used.
> 
> In three drivers I've also removed printk's printing them since they 
> were part of several printk's in a row and it doesn't make sense to 
> print ancient version information to the user.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

I'm fine with removing CVS keywords, but I do not agree with removing 
net driver version numbers that have been in the drivers for a while.

	Jeff



