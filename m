Return-Path: <linux-kernel-owner+w=401wt.eu-S1754733AbZHTNwr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733AbZHTNwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 09:52:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbZHTNwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 09:52:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58069 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbZHTNwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 09:52:46 -0400
Date: Thu, 20 Aug 2009 15:52:45 +0200
From: Jan Kara <jack@suse.cz>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       hch@infradead.org, ocfs2-devel@oss.oracle.com,
       Joel Becker <joel.becker@oracle.com>
Subject: Re: [PATCH 02/17] vfs: Export __generic_file_aio_write() and add
	some comments
Message-ID: <20090820135245.GG16486@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <1250697884-22288-3-git-send-email-jack@suse.cz> <20090819202208.GA14113@ioremap.net> <20090820123137.GE16486@duck.novell.com> <20090820133028.GA28420@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090820133028.GA28420@ioremap.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-08-09 17:30:28, Evgeniy Polyakov wrote:
> On Thu, Aug 20, 2009 at 02:31:37PM +0200, Jan Kara (jack@suse.cz) wrote:
> >   Thanks for the review. BTW: I've CCed you mainly due to pohmelfs changes.
> > Will you have time to look at them?
> 
> The one where you replaced one name with another? :)
> Yes, I did.
  Well, there were two patches. Both were similarly simple but there could
be some subtleties I've missed :). So can I add your Acked-by also to those
two pohmelfs patches?

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
