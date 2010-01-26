Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193Ab0AZM6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab0AZM6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 07:58:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753035Ab0AZM6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 07:58:06 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:13120
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752969Ab0AZM6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 07:58:05 -0500
X-SpamScore: -22
X-BigFish: VPS-22(zz1432R98dN936eM62a3Lzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KWUUHT-02-AMS-02
X-M-MSG: 
Date: Tue, 26 Jan 2010 13:53:24 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [GIT PULL] oprofile fixes for v2.6.33
Message-ID: <20100126125323.GR2014@erda.amd.com>
References: <20100125192922.GQ2014@erda.amd.com>
 <20100125232318.2f68a0ad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100125232318.2f68a0ad.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Jan 2010 12:53:24.0480 (UTC) FILETIME=[8BFB7800:01CA9E86]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.01.10 23:23:18, Andrew Morton wrote:
> On Mon, 25 Jan 2010 20:29:22 +0100 Robert Richter <robert.richter@amd.com> wrote:
> 
> > Suravee Suthikulpanit (1):
> >       oprofile/x86: fix crash when profiling more than 28 events
> 
> Did you consider a cc:stable on this one?

Yes, will send it to the stable tree after I got the upstream commit
id.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

