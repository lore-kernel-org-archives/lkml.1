Return-Path: <linux-kernel-owner+w=401wt.eu-S2992551AbXEBAej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992551AbXEBAej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992553AbXEBAej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:34:39 -0400
Received: from mail.fieldses.org ([66.93.2.214]:59522 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992550AbXEBAei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:34:38 -0400
Date: Tue, 1 May 2007 20:34:31 -0400
To: Neil Brown <neilb@suse.de>
Cc: Jeff Layton <jlayton@redhat.com>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH] RPC: add wrapper for svc_reserve to account for	checksum
Message-ID: <20070502003431.GK3588@fieldses.org>
References: <20070421131523.GA18100@dantu.rdu.redhat.com> <17974.41587.666167.650575@notabene.brown> <20070501033310.GB21774@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070501033310.GB21774@fieldses.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 11:33:10PM -0400, bfields wrote:
> On Tue, May 01, 2007 at 12:14:11PM +1000, Neil Brown wrote:
> > Bruce:  does it look OK to you?
> 
> It looks sensible, but it's a little late for me--I'll take another look
> at it and run some tests tommorow.

Just to confirm--yep, loks fine.  And I did a quick connectathon run
over krb5i just to make sure.  If someone wants it:

Acked-by: J. Bruce Fields <bfields@citi.umich.edu>

--b.
