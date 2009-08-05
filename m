Return-Path: <linux-kernel-owner+w=401wt.eu-S933717AbZHEHgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717AbZHEHgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 03:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933622AbZHEHgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 03:36:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:22258 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933604AbZHEHgO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 03:36:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,327,1246863600"; 
   d="scan'208";a="480874506"
From: "Tan, Wei Chong" <wei.chong.tan@intel.com>
To: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       John Stultz <johnstul@us.ibm.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Date: Wed, 5 Aug 2009 15:34:44 +0800
Subject: RE: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
Thread-Topic: [GIT PULL] Additional x86 fixes for 2.6.31-rc5
Thread-Index: AcoSGR9GWg3pVW2XQ2ei4n7v/JhgbADhKwGg
Message-ID: <B28277FD4E0F9247A3D55704C440A140D5ADEC74@pgsmsx504.gar.corp.intel.com>
References: <200907311813.n6VIDe9S023442@voreg.hos.anvin.org>
 <alpine.LFD.2.01.0907311218080.3161@localhost.localdomain>
 <20090731195705.GA12270@elte.hu>
In-Reply-To: <20090731195705.GA12270@elte.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> Here's a suggested replacement - BUT NOTE THAT IT'S 
> ENTIRELY UNTESTED!
> 
> (Ok, so the patch is bigger than it strictly needs to be - 
> I hate repeating code, so I made that 'read PIT counter 
> twice and compare MSB' be a new helper routine)
> 
> Hmm? What do you guys think?
> 
> 		Linus
> 

Hi,

We are performing some test on the patch and will keep everyone posted with the progress soon.

Regards,
Wei Chong.
