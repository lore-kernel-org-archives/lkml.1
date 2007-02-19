Return-Path: <linux-kernel-owner+w=401wt.eu-S1752700AbXBSB54@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbXBSB54 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 20:57:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752701AbXBSB54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 20:57:56 -0500
Received: from ozlabs.org ([203.10.76.45]:34862 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700AbXBSB5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 20:57:55 -0500
Subject: Re: loopback mount EXT3 oops
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, sct@redhat.com,
       adilger@clusterfs.com,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
In-Reply-To: <45D90007.5060006@redhat.com>
References: <1171842762.7918.47.camel@localhost.localdomain>
	 <20070218163100.a4b95b3a.akpm@linux-foundation.org>
	 <45D90007.5060006@redhat.com>
Content-Type: text/plain
Date: Mon, 19 Feb 2007 12:57:01 +1100
Message-Id: <1171850221.7918.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-02-18 at 19:40 -0600, Eric Sandeen wrote:
> Andrew Morton wrote:
> > I thought Eric fixed that.  Maybe he broke it instead ;)
> 
> Eeek... I'll reserve judgment on who broke what until I see that 
> corrupted image... ;)  is it available?  How huge?

2G, but bzip'ed e2image -r is 54M:

http://ozlabs.org/~rusty/ubuntu-oopses-e2image-r.bz2 

Cheers!
Rusty.

