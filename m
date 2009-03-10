Return-Path: <linux-kernel-owner+w=401wt.eu-S1756519AbZCJTYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519AbZCJTYl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 15:24:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753238AbZCJTYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 15:24:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:60118 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862AbZCJTYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 15:24:30 -0400
Date: Wed, 11 Mar 2009 04:23:56 +0900 (JST)
Message-Id: <20090311.042356.42852970.ryusuke@osrg.net>
To: greg@kroah.com
Cc: konishi.ryusuke@lab.ntt.co.jp, akpm@linux-foundation.org, hch@lst.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Asking for inclusion of nilfs2 in the mainline kernel
From: Ryusuke Konishi <ryusuke@osrg.net>
In-Reply-To: <20090310182556.GA5730@kroah.com>
References: <20090311.015542.118514963.ryusuke@osrg.net>
	<20090310182556.GA5730@kroah.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 11 Mar 2009 04:23:56 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Tue, 10 Mar 2009 11:25:56 -0700, Greg KH wrote:
> On Wed, Mar 11, 2009 at 01:55:42AM +0900, Ryusuke Konishi wrote:
> > Hi, 
> > 
> > I've been working for the past serveral months to take review comments
> > and to continually solve users' problems come up in mainling list
> > (thanks for all giving comments and feedbacks!).  Also, I've tried to
> > stabilize API and disk format to restrict additional changes and
> > ensure backward compatibility.
> > 
> > Except adding ioctl commands for user-demanded features, I think the
> > interface was almost stabilized.  Now I'd like to ask for mainline
> > inclusion so that more people can try this in the tree.
> 
> Then submit some patches, as documented in
> Documentation/SubmittingPatches :)
> 
> thanks,

Sorry for my insufficient explanation.

In my case, the patches are maintained in the -mm tree :)

  http://userweb.kernel.org/~akpm/mmotm/

My original post was found in

  http://marc.info/?l=linux-fsdevel&m=122141951118758

and

  http://marc.info/?l=linux-fsdevel&m=121920195516073  (undivided first post)

Additional patches have been posted to these mailing list, too.


Thanks,
Ryusuke
