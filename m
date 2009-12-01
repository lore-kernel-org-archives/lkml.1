Return-Path: <linux-kernel-owner+w=401wt.eu-S1753905AbZLAR1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbZLAR1E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 12:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbZLAR1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 12:27:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553AbZLAR1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 12:27:01 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0912010821170.2872@localhost.localdomain>
References: <alpine.LFD.2.00.0912010821170.2872@localhost.localdomain> <6941.1259681771@redhat.com> <20091201161455.GB24897@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, Ingo Molnar <mingo@elte.hu>,
       akpm@linux-foundation.org, steved@redhat.com, jens.axboe@oracle.com,
       linux-cachefs@redhat.com, nfsv4@linux-nfs.org,
       linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org
Subject: Re: [PATCH] SLOW_WORK: Move slow_work's proc file to debugfs
Date: Tue, 01 Dec 2009 17:26:22 +0000
Message-ID: <9330.1259688382@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Btw David, for things like this, it's _really_ nice to use git rename 
> detection. The diffstat (w/ summary) with rename detection looks like 
> this:

Yeah...  I upgraded to F12 and now StGIT is fighting Exim when I try to mail
patches, so I'm having to do my patches my hand until I fix it:-(

David
