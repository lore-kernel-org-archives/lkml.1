Return-Path: <linux-kernel-owner+w=401wt.eu-S1751187AbXECTO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbXECTO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 15:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbXECTO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 15:14:56 -0400
Received: from amsfep19-int.chello.nl ([62.179.120.14]:57453 "EHLO
	amsfep19-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXECTOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 15:14:55 -0400
Subject: Re: [GIT] NFS client updates for 2.6.22...
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, nfs@lists.sourceforge.net
In-Reply-To: <1178117571.5435.10.camel@heimdal.trondhjem.org>
References: <1178117571.5435.10.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Thu, 03 May 2007 21:14:51 +0200
Message-Id: <1178219691.24217.20.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-02 at 07:52 -0700, Trond Myklebust wrote:
> Hi Linus,
> 
> Please pull from the repository at
> 
>    git pull git://git.linux-nfs.org/pub/linux/nfs-2.6.git

I can confirm that this solves my missing IO completions problem; or at
least, my test has been running for 8h+ and still going strong, whereas
previous I would be lucky to get 1h.

Would it be reasonable to include the relevant patches in a
later .21-stable release?

