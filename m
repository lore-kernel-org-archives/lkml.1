Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbXI0UKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbXI0UKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 16:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbXI0UKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 16:10:08 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:59390 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbXI0UKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 16:10:06 -0400
Subject: Re: 2.6.23-rc8-mm2: BUG near reiserfs_xattr_set
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Laurent Riffard <laurent.riffard@free.fr>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, reiserfs-devel@vger.kernel.org
In-Reply-To: <20070927124833.d2691813.akpm@linux-foundation.org>
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>
	 <46FC021F.8060109@free.fr>
	 <20070927124833.d2691813.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 27 Sep 2007 13:05:13 -0700
Message-Id: <1190923513.7344.14.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-27 at 12:48 -0700, Andrew Morton wrote:
> 
> Hi, Dave!
> 
> > It's fully reproducible.
> > 
> > /home is mounted with the following options:
> >    /dev/mapper/vglinux1-lvhome on /home type reiserfs
> (rw,noatime,nodiratime,user_xattr)
> > 
> > This BUG happened with rc8-mm1 too.
> > rc6-mm1 works fine.
> > I didn't try rc7-mm1. 

Got it.  I'll try to reproduce.  

-- Dave

