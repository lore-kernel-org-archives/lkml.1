Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbYGXCYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbYGXCYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 22:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbYGXCYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 22:24:03 -0400
Received: from mail5.tpgi.com.au ([203.12.160.101]:51847 "EHLO
	mail5.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbYGXCYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 22:24:01 -0400
X-Greylist: delayed 71376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Jul 2008 22:24:00 EDT
X-TPG-Antivirus: Passed
Subject: Re: [E1000-devel] kernel crunch to a halt with e1000e driver
From: Will Trives <will@trivescon.com.au>
To: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: linux-kernel@vger.kernel.org, e1000-devel@lists.sourceforge.net
In-Reply-To: <9929d2390807230842m410d34fdq8647ce6d7a063a9c@mail.gmail.com>
References: <1216794851.4074.42.camel@Athas>
	 <9929d2390807230842m410d34fdq8647ce6d7a063a9c@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 12:22:47 +1000
Message-Id: <1216866167.3439.0.camel@Athas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I updated and no longer experience the issue. Thank you.

On Wed, 2008-07-23 at 08:42 -0700, Jeff Kirsher wrote:
> On Tue, Jul 22, 2008 at 11:34 PM, Will Trives <will@trivescon.com.au> wrote:
> > Hello guys,
> >
> > Latest linux git tree, noticed the e1000 driver no longer worked with my
> > pci express nic. e1000e works but has the following bug...
> >
> > Problem: When system grinds to a halt when unplugging the cord from the
> > nic.
> >
> > Let me know if you need any more info.
> >
> > Kernel Message:
> >
> > ul 23 15:59:28 Athas eth0: Link is Up 1000 Mbps Full Duplex, Flow
> > Control: None
> > Jul 23 15:59:28 Athas ------------[ cut here ]------------
> > Jul 23 15:59:28 Athas kernel BUG at net/core/dev.c:1328!
> 
> This should be fixed in the latest git tree.  Please pull the latest
> git tree (Torvalds) and let me know if you still see this issue.
> 

