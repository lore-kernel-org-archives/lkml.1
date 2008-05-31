Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYEaTyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYEaTyU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbYEaTyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 15:54:00 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48958 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412AbYEaTxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 15:53:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4841ACAB.5020103@s5r6.in-berlin.de>
Date: Sat, 31 May 2008 21:53:15 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.13) Gecko/20080419 SeaMonkey/1.1.9
MIME-Version: 1.0
To: Grant Grundler <grundler@google.com>
CC: Greg KH <greg@kroah.com>, "Luck, Tony" <tony.luck@intel.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: How many contributors are we losing
References: <20080528225136.GA29014@kroah.com>	 <1FE6DD409037234FAB833C420AA843EC016FFF69@orsmsx424.amr.corp.intel.com>	 <20080529003657.GA17505@kroah.com> <20080529010055.GA31952@redhat.com>	 <20080529022632.GB5180@kroah.com>	 <1FE6DD409037234FAB833C420AA843EC017405EB@orsmsx424.amr.corp.intel.com>	 <20080530204700.GA3807@kroah.com> <da824cf30805301637l2aa80d46l3d941eba92212995@mail.gmail.com>
In-Reply-To: <da824cf30805301637l2aa80d46l3d941eba92212995@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Grundler wrote:
> On Fri, May 30, 2008 at 1:47 PM, Greg KH <greg@kroah.com> wrote:
>> And I think that shows we are easy to get a
>> change into our tree from just about anyone, not that we are driving
>> people away.
> 
> I still don't buy this. I've been contributing to linux kernel since about
> 1999 and it's definitely not getting easier.  The size of SubmittingPatches
> is one indicator of how much work it is to submit a patch.
> SubmittingPatches is now 600 lines (3400+ words).

This growth of SubmittingPatches and related documents also partly means 
that we now have
   - more tools available for QA before posting,
   - more documentation on these tools,
   - more comprehensive documentation on the workflows.
To some degree, this should make contributions easier rather than harder.

It may of course also mean that some expectations are higher now, as you 
are saying AFAIU.  However, with scarce reviewer base (and scarce early 
testers base, compared to the whole userbase), it's not a bad thing for 
the project health if patches, when first posted, already have a good 
level of quality.  We want many good contributions, not just many 
contributions.  Of course if there were many reviewers and many mentors, 
than we could do with lower initial quality of submissions.
-- 
Stefan Richter
-=====-==--- -=-= =====
http://arcgraph.de/sr/
