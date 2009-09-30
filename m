Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbZI3Jw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbZI3Jw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 05:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZI3Jwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 05:52:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:29576 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136AbZI3Jwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 05:52:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,479,1249282800"; 
   d="scan'208";a="193406861"
From: "Sosnowski, Maciej" <maciej.sosnowski@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>,
       Linus Walleij <linus.walleij@stericsson.com>
CC: "Williams, Dan J" <dan.j.williams@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 30 Sep 2009 10:52:48 +0100
Subject: RE: [PATCH 1/2] Add COH 901 318 DMA block driver
Thread-Topic: [PATCH 1/2] Add COH 901 318 DMA block driver
Thread-Index: AcpBsZMd0ovP7RdoRg+WNidZpNLn1wAATu7A
Message-ID: <129600E5E5FB004392DDC3FB599660D7B78C90A1@irsmsx504.ger.corp.intel.com>
References: <1253630313-20225-1-git-send-email-linus.walleij@stericsson.com>
 <63386a3d0909300237i5d2e8fe0k80672e429a4f1917@mail.gmail.com>
In-Reply-To: <63386a3d0909300237i5d2e8fe0k80672e429a4f1917@mail.gmail.com>
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

I am in the middle of reviewing the code right now.
I could not do this earlier, as I was on vacation till yesterday.
Hopefully I will be able to send my feedback today/tomorrow.

Regards,
Maciej

-----Original Message-----
From: Linus Walleij [mailto:linus.ml.walleij@gmail.com] 
Sent: Wednesday, September 30, 2009 11:37 AM
To: Linus Walleij
Cc: Sosnowski, Maciej; Williams, Dan J; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Add COH 901 318 DMA block driver

2009/9/22 Linus Walleij <linus.walleij@stericsson.com>:

> This patch adds support for the ST-Ericsson COH 901 318 DMA block,
> found in the U300 series platforms. It registers a DMA slave for
> device I/O and also a memcpy slave for memcpy.

Are there no further comments on this DMA driver or are the subsystem
maintainers simply busy right now?

Linus Walleij
