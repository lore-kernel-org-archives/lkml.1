Return-Path: <linux-kernel-owner+w=401wt.eu-S933047AbZHDQoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933047AbZHDQoL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 12:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932899AbZHDQoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 12:44:11 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:10714
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932871AbZHDQoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 12:44:10 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz62a3L1432R98dN936eMzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNV2HA-03-QPW-01
Date: Tue, 4 Aug 2009 18:43:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Zdenek Kabelac <zdenek.kabelac@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       oprofile-list@lists.sf.net
Subject: Re: Oprofile warnings
Message-ID: <20090804164353.GC25478@erda.amd.com>
References: <c4e36d110908040812k48dfc946ka9a0161d7aa03031@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <c4e36d110908040812k48dfc946ka9a0161d7aa03031@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 04 Aug 2009 16:44:00.0310 (UTC) FILETIME=[C47D5560:01CA1522]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.08.09 17:12:43, Zdenek Kabelac wrote:
> Hi
> 
> These two warning messages appeared in my message log while using oprofile.
> (2.6.31-rc5 and oprofile-0.9.4-13.fc12.x86_64)

I sent out a fix of the ring buffer code to Steven and lkml on Jul
31. The patch is not yet in a tree.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

