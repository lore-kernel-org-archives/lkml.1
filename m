Return-Path: <linux-kernel-owner+w=401wt.eu-S1754119AbYI3A5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbYI3A5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 20:57:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752383AbYI3A4z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 20:56:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:56668 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbYI3A4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 20:56:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,334,1220252400"; 
   d="scan'208";a="341966067"
From: "Nakajima, Jun" <jun.nakajima@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
       "akataria@vmware.com" <akataria@vmware.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       "avi@redhat.com" <avi@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Zach Amsden <zach@vmware.com>,
       Daniel Hecht <dhecht@vmware.com>
Date: Mon, 29 Sep 2008 17:56:47 -0700
Subject: RE: Use CPUID to communicate with the hypervisor.
Thread-Topic: Use CPUID to communicate with the hypervisor.
Thread-Index: AckilGPmM3rCO52FS6K9D7xkGmEa0gAAQN9w
Message-ID: <0B53E02A2965CE4F9ADB38B34501A3A15726E51D@orsmsx505.amr.corp.intel.com>
References: <1222472815.29886.43.camel@alok-dev1>
	 <48E090B6.2080809@redhat.com> <1222710924.30247.21.camel@alok-dev1>
	 <48E1227B.9040809@redhat.com> <1222717085.30247.44.camel@alok-dev1>
	 <0B53E02A2965CE4F9ADB38B34501A3A15726E15A@orsmsx505.amr.corp.intel.com>
	 <48E1437D.7080606@zytor.com>  <48E1486C.3060306@goop.org>
 <1222733523.30247.91.camel@alok-dev1> <48E17363.7060103@zytor.com>
In-Reply-To: <48E17363.7060103@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m8U0vBdq027240

On 9/29/2008 5:31:31 PM, H. Peter Anvin wrote:
> Alok Kataria wrote:
> >
> > Sure, some leaves have been defined already, but it's not too late
> > to try to go the generic route for the remaining leaves.
> > The longer we wait to come to a consensus on generic leaves, the
> > more contention we will have.  So let's try to address it now.
> >
>
> We don't have a quorum to create a consensus, since we only have a
> subset of the relevant parties present.

Who else do we need here?

>         -hpa
             .
Jun Nakajima | Intel Open Source Technology Center
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
