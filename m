Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbZENPrv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbZENPrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 11:47:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751113AbZENPrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 11:47:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:63318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZENPrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 11:47:41 -0400
Date: Thu, 14 May 2009 17:52:04 +0200
From: Heinz Diehl <htd@fancy-poultry.org>
To: linux-kernel@vger.kernel.org
Cc: Theodore Tso <tytso@mit.edu>, Joseph Cihula <joseph.cihula@intel.com>,
       mingo@elte.hu, arjan@linux.intel.com, hpa@zytor.com,
       andi@firstfloor.org, chrisw@sous-sol.org, jmorris@namei.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com, John Gilmore <gnu@toad.com>
Subject: Re: [RFC v3][PATCH 2/2] intel_txt: Intel(R) TXT and tboot kernel
	support
Message-ID: <20090514155204.GA6273@fancy-poultry.org>
Reply-To: linux-kernel@vger.kernel.org
References: <4A03B9C3.9090607@intel.com>
 <20090512210154.GC23773@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090512210154.GC23773@mit.edu>
Organization: private site
User-Agent: Mutt/1.5.19+20090508 (GNU/Linux)
X-Provags-ID: V01U2FsdGVkX18swTzXAxKdju8xxsmThhxpw9kGfHbjE+t0OZ0
 ZjXYrFnjRQmSNjKS+IHtuQ2D9RsGRiMV0eZc6o60ACoiE224Gl
 LtWMZwbOLEQ7RM5UOJd3aaV0Bw2PH5r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.05.2009, Theodore Tso wrote: 

> Ross Anderson was one of the first to write about these concerns, over
> five years ago:
> 
>      http://www.cl.cam.ac.uk/~rja14/tcpa-faq.html
> 
> It's interesting that his 2003 document was able to predict the
> emergence of the LaGrande Technology (see question 15 in the above
> FAQ).

Many thanks for pointing this out!

Strange enough, nobody seems to care. I have carefully read Ross Andersons
report, and I'm more than concerned now. Because I'm not a kernel
programmer, I can not see by myself what these patches will do to the Linux
kernel at all, so I can only hope that Linus will not let them in if they 
can be misused to what Ross Anderson describes in his paper.

Regards,
Heinz.
