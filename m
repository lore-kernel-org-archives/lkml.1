Return-Path: <linux-kernel-owner+w=401wt.eu-S1753473AbYHINBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473AbYHINBH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 09:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751785AbYHINAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 09:00:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55790 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654AbYHINAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 09:00:53 -0400
Date: Sat, 9 Aug 2008 09:00:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ian Kent <raven@themaw.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       autofs mailing list <autofs@linux.kernel.org>,
       Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3/4] autofs4 - devicer node ioctl docoumentation.
Message-ID: <20080809130049.GC16308@infradead.org>
References: <20080807114002.4142.30417.stgit@web.messagingengine.com> <20080807114021.4142.39621.stgit@web.messagingengine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807114021.4142.39621.stgit@web.messagingengine.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 07:40:23PM +0800, Ian Kent wrote:
> Patch to add documentation for the miscellaneous device module of
> autofs4.

Any documentation should preferably stay withthe patch introducing
the interface.  But hopefully most of this won't be needed anyway
with the proper solution.

