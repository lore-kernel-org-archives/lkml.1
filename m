Return-Path: <linux-kernel-owner+w=401wt.eu-S933512AbYBGWAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933512AbYBGWAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 17:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760163AbYBGWAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 17:00:31 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:11114 "EHLO
	mail4-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694AbYBGWAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 17:00:30 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 149.199.60.83;Service: EHS
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Xilinx: hwicap driver comments
Date: Thu, 7 Feb 2008 14:00:22 -0800
In-Reply-To: <20080207135341.04e5652a.akpm@linux-foundation.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Xilinx: hwicap driver comments
Thread-Index: Achp0/LQQYyEJJyoQmOBrpA9mpTbNwAAES6g
References: <47AB6552.7040503@gmail.com><20080207124203.147ce300.akpm@linux-foundation.org><fa686aa40802071254p172103f0w423f4591583ca3ef@mail.gmail.com><20080207132106.ec5ebf1d.akpm@linux-foundation.org><fa686aa40802071331l16b40bacm4a7ca01a7219f1fb@mail.gmail.com><20080207213512.36FA991807D@mail185-dub.bigfish.com> <20080207135341.04e5652a.akpm@linux-foundation.org>
From: "Stephen Neuendorffer" <stephen.neuendorffer@xilinx.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: <grant.likely@secretlab.ca>, <jirislaby@gmail.com>,
       <linux-kernel@vger.kernel.org>, <paulus@samba.org>,
       <galak@gate.crashing.org>, <benh@kernel.crashing.org>,
       <torvalds@linux-foundation.org>
X-OriginalArrivalTime: 07 Feb 2008 22:00:22.0798 (UTC) FILETIME=[D63722E0:01C869D4]
Message-Id: <20080207220024.C172B1C38015@mail4-dub.bigfish.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > I'm rather new to all this and still (to some extent) trying to
figure
> > out what is expected.
> 
> We're all still trying to figure it out, really.  We've gone and made
it
> awfully easy to get code into the kernel nowadays.  Perhaps too easy.
I'm
> presently having a little campaign of watching what's going on a bit
more
> closely, and ecouraging people to make it easier for others to see
what's
> going on, should they choose to do so.
> 
> I'm hoping that by the time we're developing 2.6.26 there will be a
unified
> git tree (aka linux-next) (basically all the git and quilt trees from
-mm)
> for people to look at and play with.  That'll improve our pre-merge
test
> coverage, but won't do much to improve review.  And it won't do
anything to
> improve our post-merge bugfixing.

All of them are good, but I trust testing and sparse more than review..
:)

> > Maybe what is needed is git pull --ack?
> 
> I'm also hoping/expecting/planning that if someone tries to merge a
patch
> into mainline, and that patch hasn't been in linux-next for "long
enough",
> flags will wave and lights will flash and we can get to take a closer
look
> at why it was so late and whether it's OK.

Hmm...  what if git told you what time the original git commit happened?
That can't be that hard to add (if it's not already there!)

Steve


