Return-Path: <linux-kernel-owner+w=401wt.eu-S932862AbZAPBF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbZAPBF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:05:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbZAPBFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:05:14 -0500
Received: from relay2.sgi.com ([192.48.179.30]:59255 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754435AbZAPBFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:05:12 -0500
Date: Thu, 15 Jan 2009 19:05:11 -0600
From: "Bill O'Donnell" <billodo@sgi.com>
To: Joe Perches <joe@perches.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [XFS] Update maintainers
Message-ID: <20090116010511.GA33559@sgi.com>
References: <200901150459.n0F4xhVS016322@hera.kernel.org> <1232058936.3109.7.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1232058936.3109.7.camel@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 02:35:36PM -0800, Joe Perches wrote:
| On Thu, 2009-01-15 at 04:59 +0000, Linux Kernel Mailing List wrote:
| >     [XFS] Update maintainers
| >     New maintainer contact and new tree location.
| > ---
| >  MAINTAINERS |    4 ++--
| >  1 files changed, 2 insertions(+), 2 deletions(-)
| > 
| > diff --git a/MAINTAINERS b/MAINTAINERS
| > index a018844..5f74bce 100644
| > --- a/MAINTAINERS
| > +++ b/MAINTAINERS
| > @@ -4824,11 +4824,11 @@ S:	Supported
| >  
| >  XFS FILESYSTEM
| >  P:	Silicon Graphics Inc
| > -P:	Tim Shimmin
| > +P:	Bill O'Donnell
| >  M:	xfs-masters@oss.sgi.com
| >  L:	xfs@oss.sgi.com
| >  W:	http://oss.sgi.com/projects/xfs
| > -T:	git git://oss.sgi.com:8090/xfs/xfs-2.6.git
| > +T:	git://oss.sgi.com/xfs/xfs.git
| >  S:	Supported
| 
| Should your email address appear here?  Perhaps:
| 
| XFS FILESYSTEM
| P:	Bill O'Donnell
| M:	billodo@sgi.com
| P:	Silicon Graphics Inc
| M:	xfs-masters@oss.sgi.com
| L:	xfs@oss.sgi.com
| W:	http://oss.sgi.com/projects/xfs
| T:	git://oss.sgi.com/xfs/xfs.git
| S:	Supported
| 

No, I'd prefer we keep the maintainer contact address 
as a centralized SGI mail address.  In fact, it would be 
best if we remove my name entirely, and leave contact 
completely centralized to SGI.  I propose the 
following:

XFS FILESYSTEM
P:	Silicon Graphics Inc
M:	xfs-masters@oss.sgi.com
L:	xfs@oss.sgi.com
W:	http://oss.sgi.com/projects/xfs
T:	git://oss.sgi.com/xfs/xfs.git
S:	Supported



