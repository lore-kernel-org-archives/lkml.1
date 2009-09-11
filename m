Return-Path: <linux-kernel-owner+w=401wt.eu-S1753858AbZIKDxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbZIKDxQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 23:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZIKDxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 23:53:15 -0400
Received: from old-tantale.fifi.org ([64.81.30.200]:32927 "EHLO
	old-tantale.fifi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbZIKDxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 23:53:15 -0400
X-Greylist: delayed 1428 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Sep 2009 23:53:14 EDT
To: john stultz <johnstul@us.ibm.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Clock incorrect on 2.6.31-rc2
References: <20090709141000.584d199a@nehalam>
	<1f1b08da0907091458r19ff62c6md4436c86baf9254d@mail.gmail.com>
	<20090709153855.6230729e@nehalam> <1247181779.3259.6.camel@work-vm>
	<20090709163055.115d5878@nehalam>
	<87hbxfxgct.fsf@old-tantale.fifi.org>
	<1247698635.7511.181.camel@localhost.localdomain>
Mail-Copies-To: nobody
From: Philippe Troin <phil@fifi.org>
Date: 10 Sep 2009 20:29:27 -0700
In-Reply-To: <1247698635.7511.181.camel@localhost.localdomain>
Message-ID: <87hbva40rs.fsf@old-tantale.fifi.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz <johnstul@us.ibm.com> writes:

> On Tue, 2009-07-14 at 11:35 -0700, Philippe Troin wrote:
> > Stephen Hemminger <shemminger@vyatta.com> writes:
> > 
> > > > I'm a little stumped.  Does the problem occur on every reboot? How long
> > > > does the box need to be up before you see an issue?  Or does it go away
> > > > after a little while?
> > > 
> > > It seemed to take a while (several hours). I will leave it running overnight
> > 
> > Interestingly, I am seeing the same problem on two boxes with
> > 2.6.2{5,6}.  I haven't checked yet more recent kernels.
> 
> I suspect your issue and Stephen's issue are separate. 

Indeed.
 
The problem is fixed as of 2.6.29 (might have been fixed earlier, I
just checked this kernel version).

Phil.
