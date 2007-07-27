Return-Path: <linux-kernel-owner+w=401wt.eu-S1762599AbXG0S35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762599AbXG0S35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:29:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757382AbXG0S3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:29:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:47990 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757338AbXG0S3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:29:50 -0400
X-Authenticated: #9962044
X-Provags-ID: V01U2FsdGVkX1/ZNAxrK3PZwDSyuYXqe2ZAHbzINABTMd0HmSEwbj
	WJp+eeXkEA/Bap
From: Marc Dietrich <marvin24@gmx.de>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: Re: NFSv4 poops itself
Date: Fri, 27 Jul 2007 20:29:48 +0200
User-Agent: KMail/1.9.5
Cc: Jeff Garzik <jeff@garzik.org>,
       "Dr. J. Bruce Fields" <bfields@fieldses.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <46A9EAB0.3090306@garzik.org> <1185543187.6586.10.camel@localhost> <1185556178.6586.40.camel@localhost>
In-Reply-To: <1185556178.6586.40.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707272029.49521.marvin24@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Am Freitag, 27. Juli 2007 19:09 schrieb Trond Myklebust:
> On Fri, 2007-07-27 at 09:33 -0400, Trond Myklebust wrote:
> (...)
> Jeff and Bruce, could you please try to reproduce the problem after
> either applying patches 001 to 004 or just the single NFS_ALL patch
> from
>
>    http://client.linux-nfs.org/Linux-2.6.x/2.6.23-rc1/

as posted earlier, 001-002 does not fix it. Then I also applied 003+004 and it 
seems to be fixed now. kde boots up and I can start some programs, which I 
couldn't before. 

The "inconsistent lock state" error still exists, but it really seems to be 
unrelated.


> Cheers
>   Trond

thanks

Marc
