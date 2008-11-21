Return-Path: <linux-kernel-owner+w=401wt.eu-S1756185AbYKUNBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbYKUNBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 08:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbYKUNAt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 08:00:49 -0500
Received: from mail2.shareable.org ([80.68.89.115]:42256 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbYKUNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 08:00:49 -0500
Date: Fri, 21 Nov 2008 13:00:30 +0000
From: Jamie Lokier <jamie@shareable.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, trond.myklebust@fys.uio.no,
       viro@ZenIV.linux.org.uk, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 24/45] CacheFiles: Add a hook to write a single page of data to an inode [ver #41]
Message-ID: <20081121130030.GE29831@shareable.org>
References: <20081121002317.69e4fd11.akpm@linux-foundation.org> <20081120144139.10667.75519.stgit@warthog.procyon.org.uk> <20081120144343.10667.530.stgit@warthog.procyon.org.uk> <3843.1227271421@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3843.1227271421@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couldn't we just skip the "wasted" comment lines and go to //-style
comments, since it's been standard GCC for what, 13 years now?  And
standard ANSI C for some 9 years...

:-)

-- Jamie

