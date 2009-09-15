Return-Path: <linux-kernel-owner+w=401wt.eu-S1753907AbZION3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907AbZION3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 09:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbZION3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 09:29:45 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:10866
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753896AbZION3o convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:29:44 -0400
X-SpamScore: -3
X-BigFish: VPS-3(zz98dNzz1202hzzz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KQ0LH9-03-KMA-01
Date: Tue, 15 Sep 2009 15:29:34 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Andreas Herrmann <andreas.herrmann3@amd.com>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>, x86 <x86@kernel.org>,
       Doug Thompson <norsk5@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: [origin tree build failure] Re: [GIT PULL] AMD64 EDAC updates,
 p1
Message-ID: <20090915132934.GB3824@aftab>
References: <20090914171905.GD13615@aftab>
 <20090915110940.GA8134@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090915110940.GA8134@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 15 Sep 2009 13:29:34.0760 (UTC) FILETIME=[90A12A80:01CA3608]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 01:09:40PM +0200, Ingo Molnar wrote:
> I did the patchlet below but this needs a cleaner fix eventually. A 
> proper node abstraction needs to be factored out and provided as a 
> facility regardless of config settings.

Agreed, Andreas will have something in a while and I could add it to the
next pull request after its acked, if you don't mind.

-- 
Regards/Gruss,
Boris.

Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632

