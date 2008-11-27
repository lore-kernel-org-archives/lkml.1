Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbYK0JkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbYK0JkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751380AbYK0Jju
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:39:50 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751334AbYK0Jjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:39:49 -0500
Date: Thu, 27 Nov 2008 04:39:42 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/6] fs: Scalability of sockets/pipes
	allocation/deallocation on SMP
Message-ID: <20081127093942.GA13860@infradead.org>
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com> <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDB6A.8090806@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492DDB6A.8090806@cosmosbay.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As I told you before, you absolutely must include the fsdevel list and
the VFS maintainer for a patchset like this.
