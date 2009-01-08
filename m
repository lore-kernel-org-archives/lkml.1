Return-Path: <linux-kernel-owner+w=401wt.eu-S1761574AbZAHSU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761574AbZAHSU1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 13:20:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755703AbZAHSUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 13:20:17 -0500
Received: from mail.fieldses.org ([141.211.133.115]:58215 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbZAHSUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 13:20:15 -0500
Date: Thu, 8 Jan 2009 13:20:03 -0500
To: Ian Campbell <ijc@hellion.org.uk>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>, linux-nfs@vger.kernel.org,
       Max Kellermann <mk@cm4all.com>, linux-kernel@vger.kernel.org,
       gcosta@redhat.com, Grant Coady <grant_lkml@dodo.com.au>,
       Tom Tucker <tom@opengridcomputing.com>
Subject: Re: [PATCH 0/3] NFS regression in 2.6.26?, "task blocked for more
	than 120 seconds"
Message-ID: <20090108182003.GB17623@fieldses.org>
References: <1227621434.7057.33.camel@heimdal.trondhjem.org> <1227621877.9425.102.camel@zakaz.uk.xensource.com> <1227737539.31008.2.camel@localhost.localdomain> <1228090631.7112.11.camel@heimdal.trondhjem.org> <1228169383.20370.3.camel@localhost.localdomain> <1228565812.10856.30.camel@localhost.localdomain> <1229279045.3721.1.camel@localhost.localdomain> <20081216175503.GG16388@fieldses.org> <1229452775.3721.25.camel@localhost.localdomain> <20090107222115.GI965@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090107222115.GI965@fieldses.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2009 at 05:21:15PM -0500, J. Bruce Fields wrote:
> On Tue, Dec 16, 2008 at 06:39:35PM +0000, Ian Campbell wrote:
> > That's right, it was actually 2.6.26.7 FWIW.
> > 
> > > I'll try to take a look at these before I leave for the holidays,
> > > assuming the versions Trond posted on Nov. 30 are the latest.
> > 
> > Thanks.
> 
> Sorry for getting behind.
> 
> If you got a chance to retest with the for-2.6.29 branch at
> 
> 	git://linux-nfs.org/~bfields/linux.git for-2.6.29
> 
> that'd be great; that's what I intend to send to Linus.

(Merged now, so testing mainline as of today should work too.)

--b.
