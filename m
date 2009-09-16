Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbZIPE66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbZIPE66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 00:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbZIPE6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 00:58:55 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:30673 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbZIPE6z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 00:58:55 -0400
X-SpamScore: -9
X-BigFish: VPS-9(zz1432R98dN936eM9371Pzz1202hzz3198u327alz32i203h6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQ1SHO-03-9YK-01
Date: Wed, 16 Sep 2009 06:58:47 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, x86@kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] edac: need to export cpu_llc_id
Message-ID: <20090916045847.GC5767@aftab>
References: <20090916093935.6bc2c91f.sfr@canb.auug.org.au>
 <20090916044151.GB5767@aftab>
 <4AB06EE3.4010509@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <4AB06EE3.4010509@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Sep 2009 04:58:46.0932 (UTC) FILETIME=[5F837D40:01CA368A]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 09:51:47PM -0700, H. Peter Anvin wrote:
> On 09/15/2009 09:41 PM, Borislav Petkov wrote:
> > 
> > proper fix is at http://marc.info/?l=linux-kernel&m=125302459621925
> > 
> > we still have to figure out who's gonna pick it up. Ingo?
> > 
> 
> This was from a tree you pushed straight to Linus, so it's probably
> better you push it directly.
> 
> You can add:
> 
> Acked-by: H. Peter Anvin <hpa@zytor.com>

Cool, thanks. Will prep a pull request in a couple of hours.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

