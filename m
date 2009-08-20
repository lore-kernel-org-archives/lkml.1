Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZHTMbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZHTMbk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 08:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754141AbZHTMbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 08:31:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:56628 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbZHTMbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 08:31:39 -0400
Date: Thu, 20 Aug 2009 14:31:37 +0200
From: Jan Kara <jack@suse.cz>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       hch@infradead.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>
Subject: Re: [PATCH 02/17] vfs: Export __generic_file_aio_write() and add
	some comments
Message-ID: <20090820123137.GE16486@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-3-git-send-email-jack@suse.cz> <20090819202208.GA14113@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090819202208.GA14113@ioremap.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-08-09 00:22:08, Evgeniy Polyakov wrote:
> Hi.
> 
> On Wed, Aug 19, 2009 at 06:04:29PM +0200, Jan Kara (jack@suse.cz) wrote:
> > Rename __generic_file_aio_write_nolock() to __generic_file_aio_write(), add
> > comments to write helpers explaining how they should be used and export
> > __generic_file_aio_write() since it will be used by some filesystems.
> 
> Looks good to me. And comments are definitely good.
> Ack.
  Thanks for the review. BTW: I've CCed you mainly due to pohmelfs changes.
Will you have time to look at them?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
