Return-Path: <linux-kernel-owner+w=401wt.eu-S1755972AbXD0Tpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972AbXD0Tpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:45:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755910AbXD0Tpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:45:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:39204 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755972AbXD0TpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:45:00 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+oakIEFvqoIhepPOcq2eYEJ7+B7UMCs5ITj1MHTm
	XhdDrBOyBNFWMp
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
From: Mike Galbraith <efault@gmx.de>
To: Andreas Dilger <adilger@clusterfs.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Marat Buharov <marat.buharov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       Alex Tomas <alex@clusterfs.com>
In-Reply-To: <20070427193130.GD5967@schatzie.adilger.int>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>
	 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com>
	 <alpine.LFD.0.98.0704270819500.9964@woody.linux-foundation.org>
	 <20070427193130.GD5967@schatzie.adilger.int>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 21:44:57 +0200
Message-Id: <1177703097.7088.17.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-27 at 13:31 -0600, Andreas Dilger wrote:
> I believe
> Alex has a patch to have it checkpoint much smaller chunks to the fs.

I wouldn't be averse to test driving such a patch (understatement). You
have a pointer?

	-Mike

