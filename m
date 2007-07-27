Return-Path: <linux-kernel-owner+w=401wt.eu-S937594AbXG0RQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937594AbXG0RQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 13:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932912AbXG0RQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 13:16:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59537 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763732AbXG0RQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 13:16:39 -0400
Message-ID: <46AA2872.9040800@garzik.org>
Date: Fri, 27 Jul 2007 13:16:34 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>
CC: "Dr. J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: NFSv4 poops itself
References: <46A9EAB0.3090306@garzik.org>	 <1185543187.6586.10.camel@localhost> <1185556178.6586.40.camel@localhost>
In-Reply-To: <1185556178.6586.40.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Trond Myklebust wrote:
> Jeff and Bruce, could you please try to reproduce the problem after
> either applying patches 001 to 004 or just the single NFS_ALL patch
> from 
> 
>    http://client.linux-nfs.org/Linux-2.6.x/2.6.23-rc1/


It's not easily reproducible here.  Any hints on triggering the behavior?

	Jeff


