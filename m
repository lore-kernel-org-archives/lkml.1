Return-Path: <linux-kernel-owner+w=401wt.eu-S1757827AbZJBNVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757827AbZJBNVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 09:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbZJBNVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 09:21:12 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:12941 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816AbZJBNVL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 09:21:11 -0400
X-SpamScore: -5
X-BigFish: VPS-5(z39eeh518kz1453M98dNzz1202hzzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQW2EB-04-7H0-02
X-M-MSG: 
Date: Fri, 2 Oct 2009 15:21:01 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <petkovbb@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: mce: Please revert
 22223c9b417be5fd0ab2cf9ad17eb7bd1e19f7b9
Message-ID: <20091002132101.GA28682@aftab>
References: <20090930204643.GA24862@elte.hu>
 <20090930214859.GA28638@elte.hu>
 <20090930223956.GE17712@liondog.tnic>
 <20090930230947.GA9346@elte.hu>
 <20091001141432.GA11410@aftab>
 <alpine.LFD.2.01.0910010731130.6996@localhost.localdomain>
 <20091001144637.GB11410@aftab>
 <20091001150046.GA21476@elte.hu>
 <20091001152140.GC11410@aftab>
 <20091001153250.GA25885@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20091001153250.GA25885@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 02 Oct 2009 13:20:33.0147 (UTC) FILETIME=[1ED354B0:01CA4363]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 01, 2009 at 05:32:50PM +0200, Ingo Molnar wrote:
> Yeah, that would be good. It should also obviously depend on 
> CONFIG_X86_MCE - so only visible if MCE support is enabled.

Ok, here are the patches with the discussed changes added. By the way,
do we want that lot in .32 still or should I queue them up for the merge
window next year :) ?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

