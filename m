Return-Path: <linux-kernel-owner+w=401wt.eu-S1751109AbXEXPuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109AbXEXPuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 11:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750707AbXEXPuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 11:50:09 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:33664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702AbXEXPuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 11:50:08 -0400
Date: Thu, 24 May 2007 08:49:12 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Diego Calleja <diegocg@gmail.com>
cc: Qi Yong <qiyong@fc-cn.com>,
       "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       debian developer <debiandev@gmail.com>, greg@kroah.com,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH - 1/1] Documentation/HOWTO
In-Reply-To: <20070524135633.53260eb3.diegocg@gmail.com>
Message-ID: <alpine.LFD.0.98.0705240847160.26602@woody.linux-foundation.org>
References: <f24d23310705180629x50c56ayfdcde357f0373fc4@mail.gmail.com>
 <Pine.LNX.4.64.0705181200440.18186@localhost.localdomain>
 <10867.1179509181@turing-police.cc.vt.edu> <2cd57c900705240245s5448257ape203deade7812121@mail.gmail.com>
 <20070524135633.53260eb3.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1766080780-1180021753=:26602"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1766080780-1180021753=:26602
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT



On Thu, 24 May 2007, Diego Calleja wrote:
> El Thu, 24 May 2007 17:45:04 +0800, "Qi Yong" <qiyong@fc-cn.com> escribió:
> 
> D'oh, it seems the patch was picked from the mailing list and merged twice,
> and I didn't notice it.
> 
> > Torvalds, Care to revert one commit?
> 
> Agreed, one of them can be removed.

Yes, done.

Andrew - can you check that it's also removed from your queues, since it 
might be there still just because it keeps applying cleanly.

You might have it described as "HOWTO: mention bughunting" rather than 
"HOWTO: bug report addition".

		Linus
---1463790079-1766080780-1180021753=:26602--
