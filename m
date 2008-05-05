Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbYEELBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbYEELBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 07:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758385AbYEEK7v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 06:59:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758326AbYEEK7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 06:59:49 -0400
Date: Mon, 5 May 2008 06:59:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 02/15] nfsd: clean up mnt_want_write calls
Message-ID: <20080505105930.GB20910@infradead.org>
References: <20080505095440.820370974@szeredi.hu> <20080505095509.480855416@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505095509.480855416@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 11:54:43AM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Multiple mnt_want_write() calls in the switch statement looks really
> ugly.

agreed.  nice cleanup.

