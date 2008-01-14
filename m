Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbYANO02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbYANO02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 09:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbYANO0G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 09:26:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54664 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbYANO0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 09:26:04 -0500
Date: Mon, 14 Jan 2008 14:25:56 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       neilb@suse.de, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] NLM: Initialize completion variable in lockd_up
Message-ID: <20080114142555.GA1783@infradead.org>
References: <1199820798-5289-1-git-send-email-jlayton@redhat.com> <1199820798-5289-2-git-send-email-jlayton@redhat.com> <1199820798-5289-3-git-send-email-jlayton@redhat.com> <1199820798-5289-4-git-send-email-jlayton@redhat.com> <20080109173542.GA30523@infradead.org> <20080113082718.396890f7@tleilax.poochiereds.net> <20080113181743.GA20219@infradead.org> <20080114092454.66a41c29@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114092454.66a41c29@tleilax.poochiereds.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2008 at 09:24:54AM -0500, Jeff Layton wrote:
> Thanks Christoph. I incorporated this into my latest patchset. It does
> seem to fix the issue (tested by bouncing NFS up and down for 30 mins
> or so). Let me know if you want me to add a signed-off-by line for
> you...

No need to add anything, this was just a two-liner trivial fix..

