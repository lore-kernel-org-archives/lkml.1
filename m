Return-Path: <linux-kernel-owner+w=401wt.eu-S1752365AbZHSUWK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbZHSUWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:22:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbZHSUWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:22:09 -0400
Received: from matrixpower.ru ([195.178.208.66]:32948 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbZHSUWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:22:08 -0400
Date: Thu, 20 Aug 2009 00:22:08 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
       ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>
Subject: Re: [PATCH 02/17] vfs: Export __generic_file_aio_write() and add some comments
Message-ID: <20090819202208.GA14113@ioremap.net>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-3-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250697884-22288-3-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Aug 19, 2009 at 06:04:29PM +0200, Jan Kara (jack@suse.cz) wrote:
> Rename __generic_file_aio_write_nolock() to __generic_file_aio_write(), add
> comments to write helpers explaining how they should be used and export
> __generic_file_aio_write() since it will be used by some filesystems.

Looks good to me. And comments are definitely good.
Ack.

-- 
	Evgeniy Polyakov
