Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbZHTN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbZHTN6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbZHTN6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:58:18 -0400
Received: from tservice.ru ([195.178.208.66]:53763 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbZHTN6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:58:18 -0400
Date: Thu, 20 Aug 2009 17:58:18 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, hch@infradead.org,
       ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>
Subject: Re: [PATCH 02/17] vfs: Export __generic_file_aio_write() and add some comments
Message-ID: <20090820135818.GA29564@ioremap.net>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-3-git-send-email-jack@suse.cz> <20090819202208.GA14113@ioremap.net> <20090820123137.GE16486@duck.novell.com> <20090820133028.GA28420@ioremap.net> <20090820135245.GG16486@duck.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820135245.GG16486@duck.novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 03:52:45PM +0200, Jan Kara (jack@suse.cz) wrote:
>   Well, there were two patches. Both were similarly simple but there could

As of sync behaviour - pohmelfs will follow the usual VFS behaviour, so
if you managed to break this, we still will follow the mainstream :)

> be some subtleties I've missed :). So can I add your Acked-by also to those
> two pohmelfs patches?

Sure.

-- 
	Evgeniy Polyakov
