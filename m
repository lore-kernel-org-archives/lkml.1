Return-Path: <linux-kernel-owner+w=401wt.eu-S1759493AbZIPQFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759493AbZIPQFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759481AbZIPQFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:05:30 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:58089
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759483AbZIPQF1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:05:27 -0400
X-SpamScore: 0
X-BigFish: VPS0(zz1432R1453M98dN873fizz1202hzz3198u327alz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KQ2NCW-01-CGN-02
X-M-MSG: 
Date: Wed, 16 Sep 2009 18:04:20 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] edac: need to export cpu_llc_id
Message-ID: <20090916160420.GA12585@aftab>
References: <20090916093935.6bc2c91f.sfr@canb.auug.org.au>
 <20090916044151.GB5767@aftab>
 <20090917014901.1011949d.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090917014901.1011949d.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Sep 2009 16:04:22.0584 (UTC) FILETIME=[5B046380:01CA36E7]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 17, 2009 at 01:49:01AM +1000, Stephen Rothwell wrote:
> Hi Boris,
> 
> On Wed, 16 Sep 2009 06:41:51 +0200 Borislav Petkov <borislav.petkov@amd.com> wrote:
> >
> > proper fix is at http://marc.info/?l=linux-kernel&m=125302459621925
> 
> Great, thanks.

By the way, fix is already underway to Linus so you might just wait
a while before applying it to your linux-next mix and pull it from
upstream instead.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

