Return-Path: <linux-kernel-owner+w=401wt.eu-S933980AbXEKWzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980AbXEKWzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 18:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760704AbXEKWzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 18:55:17 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43876 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755168AbXEKWzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 18:55:14 -0400
Message-ID: <4644F43D.5060505@garzik.org>
Date: Fri, 11 May 2007 18:54:53 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Chuck Lever <chuck.lever@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NeilBrown <neilb@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [bisect] NFS regression breaks X
References: <46423D62.2070200@garzik.org>	 <1178748206.6760.3.camel@heimdal.trondhjem.org>	 <20070509155228.d1b9d644.akpm@linux-foundation.org> <1178755813.6760.26.camel@heimdal.trondhjem.org>
In-Reply-To: <1178755813.6760.26.camel@heimdal.trondhjem.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.4 (---)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-3.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ACK -- this regression was fixed by Trond's recent NFS bugfix push upstream.

	Jeff



