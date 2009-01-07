Return-Path: <linux-kernel-owner+w=401wt.eu-S1762347AbZAGWVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762347AbZAGWVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758550AbZAGWV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:21:26 -0500
Received: from mail.fieldses.org ([141.211.133.115]:37187 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757742AbZAGWVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:21:25 -0500
Date: Wed, 7 Jan 2009 17:21:15 -0500
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-nfs@vger.kernel.org,
       Max Kellermann <mk@cm4all.com>, linux-kernel@vger.kernel.org,
       gcosta@redhat.com, Grant Coady <grant_lkml@dodo.com.au>,
       Tom Tucker <tom@opengridcomputing.com>
Subject: Re: [PATCH 0/3] NFS regression in 2.6.26?, "task blocked for more
	than 120 seconds"
Message-ID: <20090107222115.GI965@fieldses.org>
References: <1227620339.9425.99.camel@zakaz.uk.xensource.com> <1227621434.7057.33.camel@heimdal.trondhjem.org> <1227621877.9425.102.camel@zakaz.uk.xensource.com> <1227737539.31008.2.camel@localhost.localdomain> <1228090631.7112.11.camel@heimdal.trondhjem.org> <1228169383.20370.3.camel@localhost.localdomain> <1228565812.10856.30.camel@localhost.localdomain> <1229279045.3721.1.camel@localhost.localdomain> <20081216175503.GG16388@fieldses.org> <1229452775.3721.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1229452775.3721.25.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 06:39:35PM +0000, Ian Campbell wrote:
> That's right, it was actually 2.6.26.7 FWIW.
> 
> > I'll try to take a look at these before I leave for the holidays,
> > assuming the versions Trond posted on Nov. 30 are the latest.
> 
> Thanks.

Sorry for getting behind.

If you got a chance to retest with the for-2.6.29 branch at

	git://linux-nfs.org/~bfields/linux.git for-2.6.29

that'd be great; that's what I intend to send to Linus.

--b.
