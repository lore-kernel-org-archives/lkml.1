Return-Path: <linux-kernel-owner+w=401wt.eu-S1756395AbZIUOzI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395AbZIUOzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:55:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbZIUOzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:55:06 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:44912
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750953AbZIUOzF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:55:05 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432R1453M98dNzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQBTFJ-03-7SO-02
X-M-MSG: 
Date: Mon, 21 Sep 2009 16:55:02 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Keith Mannthey <kmannth@us.ibm.com>
CC: lkml <linux-kernel@vger.kernel.org>, dougthompson@xmission.com
Subject: Re: [Patch] AMD64_EDAC: Fix amd64_map_to_dcs_mask
Message-ID: <20090921145502.GC23580@aftab>
References: <1253239781.7263.113.camel@keith-laptop>
 <20090918144226.GD25309@aftab>
 <1253294933.7263.129.camel@keith-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1253294933.7263.129.camel@keith-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 21 Sep 2009 14:54:52.0599 (UTC) FILETIME=[7993EC70:01CA3ACB]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keith,

On Fri, Sep 18, 2009 at 10:28:53AM -0700, Keith Mannthey wrote:
> > By the way, your patches made me look harder at that code region and
> > I've found some more problems with it which I've fixed. Would you like
> > to test the whole bunch of fixes on your setup?
> 
> Yes please send any changes you have.  I have a decent test setup for
> live errors. 

The patch queue is at

git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git

the 'edac-fixes' branch.

Please do test and let me know of any problems you might have.

Thanks a lot.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

