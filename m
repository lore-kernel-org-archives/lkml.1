Return-Path: <linux-kernel-owner+w=401wt.eu-S934078AbXGTH4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934078AbXGTH4e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 03:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758076AbXGTH40
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 03:56:26 -0400
Received: from outbound-fra.frontbridge.com ([62.209.45.174]:43481 "EHLO
	outbound3-fra-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758341AbXGTH4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 03:56:24 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: 89466532-923C-4A88-82C1-66ACAA0041DF
From: "Joachim Deguara" <joachim.deguara@amd.com>
Organization: AMD
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [PATCH] Documentation update sched-stat.txt
Date: Fri, 20 Jul 2007 09:56:03 +0200
User-Agent: KMail/1.9.7
cc: ricklind@us.ibm.com, "lkml List" <linux-kernel@vger.kernel.org>
References: <200707181111.31254.joachim.deguara@amd.com>
 <20070720072522.GB27772@wotan.suse.de>
In-Reply-To: <20070720072522.GB27772@wotan.suse.de>
MIME-Version: 1.0
Message-ID: <200707200956.03872.joachim.deguara@amd.com>
X-OriginalArrivalTime: 20 Jul 2007 07:56:05.0968 (UTC)
 FILETIME=[6CF2CD00:01C7CAA3]
X-WSS-ID: 6ABEB5137CS2920070-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 20 July 2007 09:25:22 Nick Piggin wrote:
> On Wed, Jul 18, 2007 at 11:11:30AM +0200, Joachim Deguara wrote:
> > While learning about schedstats I found that the documentation in the
> > tree is old.  I updated it and found some interesting stuff like
> > schedstats version 14 is the same as version and version 13 never saw a
> > kernel release!  Also there are 6 fields in the current schedstats that
> > are not used anymore.  Nick had made them irrelevant in commit
> > 476d139c218e44e045e4bc6d4cc02b010b343939 but never removed them.
> >
> > Thanks to Rick's perl script who I borrowed some of the updated
> > descriptions from.
>
> Ah, thanks, I actually didn't realise there was such good documentation
> there. Patch looks good.
>
> BTW. I have a simple program to do a basic statistical summary of the
> multiprocessor balancing if you are interested and haven't seen it.

Yes I am interested.  Actually I started down this road looking to find out if 
task migration could be tracked and I saw that got kicked out from early 
versions.
Your script could come in useful to link to in the documentation.  Rick has a 
great page but hasn't been updated in a little while (though still up-to-date 
as version 12==14) and his email bounced (though just a config error).

-Joachim


