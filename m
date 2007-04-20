Return-Path: <linux-kernel-owner+w=401wt.eu-S1767243AbXDTUdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767243AbXDTUdW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 16:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767242AbXDTUdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 16:33:21 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:55210 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767240AbXDTUdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 16:33:20 -0400
Subject: Re: qla2xxx hba crashes with older 2310 cards
From: James Bottomley <James.Bottomley@SteelEye.com>
To: David Miller <davem@davemloft.net>
Cc: rpeterso@redhat.com, linux-kernel@vger.kernel.org,
       andrew.vasquez@qlogic.com, hch@lst.de, linux-scsi@vger.kernel.org
In-Reply-To: <20070420.132402.119227720.davem@davemloft.net>
References: <4628DEEE.3060205@redhat.com>
	 <20070420.132402.119227720.davem@davemloft.net>
Content-Type: text/plain
Date: Fri, 20 Apr 2007 16:33:09 -0400
Message-Id: <1177101189.3718.49.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-04-20 at 13:24 -0700, David Miller wrote:
> From: Robert Peterson <rpeterso@redhat.com>
> Date: Fri, 20 Apr 2007 10:40:30 -0500
> 
> > I've seen some chatter about the qla2xxx driver but not paid attention, so
> > I'm sorry if this is a known issue.  I've got an older qlogic hba, and recent
> > drivers don't seem to play nice with it.  I've got the latest firmware from
> > qlogic's web site.  I'm using a 2.6.21-rc6 kernel from Steve Whitehouse's
> > -nmw git tree.  Reverting to an older driver (but same kernel) and it works.
> > The current driver gives this:
> 
> Yes, known problem, I'm sorry these guys broke the driver for
> you as well, please see this thread:
> 
> 	http://marc.info/?l=linux-kernel&m=117671067701124&w=2
> 
> This was really a stupid change to make.

OK,OK, we heard you the first time ... the maintainers will try to fix
this in a manner acceptable to all concerned ... could we try to cool
down the public traductions now?

James


