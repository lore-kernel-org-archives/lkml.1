Return-Path: <linux-kernel-owner+w=401wt.eu-S1759646AbZEGOi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646AbZEGOi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 10:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754669AbZEGOiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 10:38:20 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:20380
	"EHLO WA4EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754464AbZEGOiT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 10:38:19 -0400
X-BigFish: VPS-10(zz98dR936fJzz1202hzzz32i6bh6di61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KJA3BI-01-T81-01
Date: Thu, 7 May 2009 16:38:07 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: akpm@linux-foundation.org, greg@kroah.com, norsk5@yahoo.com,
       tglx@linutronix.de, hpa@zytor.com, mchehab@redhat.com, aris@redhat.com,
       edt@aei.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v3] amd64_edac: EDAC module for AMD64
Message-ID: <20090507143807.GA15923@aftab>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com> <20090507142724.GM481@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090507142724.GM481@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 07 May 2009 14:38:10.0950 (UTC) FILETIME=[71F4AA60:01C9CF21]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 07, 2009 at 04:27:24PM +0200, Ingo Molnar wrote:
> Regarding workflow, the arch/x86 bits look good to me now, so you've 
> got my Acked-by for that.

Cool, thanks.

Does that mean you're going to pick that one or...

> Most of the EDAC patches are hosted in 
> -mm, so we could carry them in the x86 tree separately as well and 
> export it to linux-next so that -mm will have it automatically.

is the bunch going through Andrew as a whole?

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

