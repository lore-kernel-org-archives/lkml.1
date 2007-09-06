Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbXIFKoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbXIFKoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 06:44:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754380AbXIFKoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 06:44:23 -0400
Received: from smtp.nokia.com ([131.228.20.171]:47340 "EHLO
	mgw-ext12.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbXIFKoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 06:44:22 -0400
Message-ID: <46DFD9F7.9070109@nokia.com>
Date: Thu, 06 Sep 2007 13:44:07 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Stefan Becker <Stefan.Becker@nokia.com>,
       ext Andi Kleen <andi@firstfloor.org>,
       ext Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [pre-2.6.23 REGRESSION] 2.6.23-rc3-git1 crash/stuck on VIA	CN700
 system
References: <46C9D148.5080505@nokia.com> <p734pibbbex.fsf@bingen.suse.de> <46DDA366.8090806@nokia.com> <20070905102525.GB31880@one.firstfloor.org> <46DECDC9.9050407@nokia.com> <20070905163724.GC31880@one.firstfloor.org> <46DF0257.5050303@nokia.com> <20070906104102.GA14070@redhat.com>
In-Reply-To: <20070906104102.GA14070@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Sep 2007 10:44:08.0417 (UTC) FILETIME=[DA626D10:01C7F072]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ext Dave Jones wrote:
> 
> Could be that even though it advertises clflush support there are
> errata on some revs of the CPU.  Can you paste your /proc/cpuinfo,
> and I'll check with VIA to find out if they're aware of any
> known problems and if so, find out the range of steppings we
> need to not use clflush on.

Please see <http://lkml.org/lkml/2007/9/5/135>

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com
