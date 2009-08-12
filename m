Return-Path: <linux-kernel-owner+w=401wt.eu-S1752614AbZHLWey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614AbZHLWey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZHLWex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:34:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49948 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896AbZHLWex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:34:53 -0400
Date: Thu, 13 Aug 2009 00:34:53 +0200
From: Jan Kara <jack@suse.cz>
To: Sylvain Rochet <gradator@gradator.net>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-nfs@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: 2.6.28.9: EXT3/NFS inodes corruption
Message-ID: <20090812223453.GC10729@duck.suse.cz>
References: <20090716172749.GC3740@atrey.karlin.mff.cuni.cz> <20090725151751.GA6419@gradator.net> <20090727154253.GB8332@duck.suse.cz> <20090728112715.GA8442@gradator.net> <20090728135226.GA21682@duck.suse.cz> <20090728164142.GA13662@gradator.net> <20090803222901.GB23162@duck.suse.cz> <20090804111505.GA6433@gradator.net> <20090804225619.GB11097@duck.suse.cz> <20090806131555.GA23359@gradator.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090806131555.GA23359@gradator.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Thu 06-08-09 15:15:56, Sylvain Rochet wrote:
> > I have one idea what could cause your filesystem corruption, although 
> > it's a wild guess... Please try attached oneliner.
> 
> Running since yesterday.
  Any news after a week of running? How often did the corruption happen
previously?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
