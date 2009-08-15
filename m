Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880AbZHOPON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880AbZHOPON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 11:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753920AbZHOPOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 11:14:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750743AbZHOPOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 11:14:12 -0400
Date: Sat, 15 Aug 2009 17:14:12 +0200
From: Nick Piggin <npiggin@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [rfc][patch 1/3] fs: new truncate sequence
Message-ID: <20090815151412.GB30951@wotan.suse.de>
References: <20090706165438.GQ2714@wotan.suse.de> <20090815145131.GA25509@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090815145131.GA25509@infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 15, 2009 at 10:51:31AM -0400, Christoph Hellwig wrote:
> Nick, what's the plan with moving forward on this?  We're badly waiting
> for it on the XFS side.  

I was hoping Al would take it but no reply... Any other git tree you
suggest, or -mm?

