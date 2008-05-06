Return-Path: <linux-kernel-owner+w=401wt.eu-S932298AbYEFJ2C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298AbYEFJ2C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:28:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764738AbYEFJQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:16:39 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55263 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755529AbYEFJQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:16:36 -0400
Date: Tue, 6 May 2008 05:16:32 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, hch@infradead.org, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/24] vfs: fixes and cleanups + add helpers to check
	r/o bind mounts
Message-ID: <20080506091632.GA28032@infradead.org>
References: <20080506091327.259950960@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080506091327.259950960@szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2008 at 11:13:27AM +0200, Miklos Szeredi wrote:
> Here it is again as a single series (without the ecryptfs one already
> merged).
> 
> I've addressed Christoph's comments.

And totally ignored Al's while merging the second rejected series into
the first one.   I also still want to go over the various
setattr-related changes, pleawse give me some time for those.

