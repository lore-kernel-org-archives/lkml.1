Return-Path: <linux-kernel-owner+w=401wt.eu-S933670AbZHEL5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670AbZHEL5l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbZHEL5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:57:40 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:11745 "EHLO
	IE1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543AbZHEL5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:57:40 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz62a3L1432R98dN936eMzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNWJVS-01-NXA-02
X-M-MSG: 
Date: Wed, 5 Aug 2009 13:56:53 +0200
From: Robert Richter <robert.richter@amd.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sf.net
Subject: Re: Oprofile warnings
Message-ID: <20090805115653.GD14610@erda.amd.com>
References: <c4e36d110908040812k48dfc946ka9a0161d7aa03031@mail.gmail.com> <20090804164353.GC25478@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090804164353.GC25478@erda.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 05 Aug 2009 11:56:54.0475 (UTC) FILETIME=[D38141B0:01CA15C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.08.09 18:43:58, Robert Richter wrote:
> On 04.08.09 17:12:43, Zdenek Kabelac wrote:
> > Hi
> > 
> > These two warning messages appeared in my message log while using oprofile.
> > (2.6.31-rc5 and oprofile-0.9.4-13.fc12.x86_64)
> 
> I sent out a fix of the ring buffer code to Steven and lkml on Jul
> 31. The patch is not yet in a tree.

I applied the patches temporarily to this branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git ring-buffer-fixes

-Robert

> 
> -Robert
> 
> -- 
> Advanced Micro Devices, Inc.
> Operating System Research Center
> email: robert.richter@amd.com

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

