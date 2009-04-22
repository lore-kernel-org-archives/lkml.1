Return-Path: <linux-kernel-owner+w=401wt.eu-S1755722AbZDVRO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbZDVRO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752612AbZDVROU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:14:20 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:8551 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbZDVROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:14:19 -0400
X-BigFish: VPS-30(z971J3dc9i6f5iz1432R98dR4015M1805M936fKzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KIIII0-01-ICW-01
Date: Wed, 22 Apr 2009 19:13:05 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Kiszka <jan.kiszka@web.de>, Jeff Mahoney <jeffm@suse.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] IO-APIC + timer doesn't work!
Message-ID: <20090422171305.GA14236@alberich.amd.com>
References: <49E89D1B.7060800@suse.com> <49E9904A.5030201@web.de> <49EA2F81.7030302@suse.com> <20090418200623.GA27294@elte.hu> <49EA373A.8060105@web.de> <20090418203227.GC30144@elte.hu> <49EA3C28.9010209@web.de> <20090422101950.GA32009@alberich.amd.com> <20090422104629.GA13086@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090422104629.GA13086@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Apr 2009 17:13:17.0357 (UTC) FILETIME=[A0CF6DD0:01C9C36D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 12:46:29PM +0200, Ingo Molnar wrote:

    ... snip ...

> Applied to tip:x86/urgent, thanks Andreas!
> 
> I've also removed the trial baloon patch below - your patch is a 
> full replacement for it, correct?

Yes.

Thanks,
Andreas


