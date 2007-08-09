Return-Path: <linux-kernel-owner+w=401wt.eu-S1755435AbXHITS3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbXHITS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 15:18:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbXHITSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 15:18:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40922 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044AbXHITSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 15:18:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <21984.1186685548@redhat.com>
References: <21984.1186685548@redhat.com> <1186683869.6699.136.camel@heimdal.trondhjem.org> <20070809160438.17906.76348.stgit@warthog.cambridge.redhat.com> <20070809160550.17906.40862.stgit@warthog.cambridge.redhat.com>
Cc: dhowells@redhat.com, Trond Myklebust <trond.myklebust@fys.uio.no>,
       torvalds@osdl.org, akpm@osdl.org, steved@redhat.com,
       linux-fsdevel@vger.kernel.org, linux-cachefs@redhat.com,
       nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] NFS: Use local caching [try #2]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Thu, 09 Aug 2007 20:15:22 +0100
Message-ID: <22462.1186686922@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > Instead, feel free to update the text-based mount interface (which can
> > be found in 2.6.23-rc1 and later).

I presume you're referring to nfs_mount_option_tokens[] and friends.  Is there
a mount program that can drive this?

David
