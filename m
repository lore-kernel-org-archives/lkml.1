Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYI3Ps5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYI3Ps5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 11:48:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753116AbYI3Pss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 11:48:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:61606 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992AbYI3Pss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 11:48:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,338,1220252400"; 
   d="scan'208";a="342221684"
From: "Allan, Bruce W" <bruce.w.allan@intel.com>
To: Jiri Kosina <jkosina@suse.cz>, Krzysztof Halasa <khc@pm.waw.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Date: Tue, 30 Sep 2008 08:48:36 -0700
Subject: RE: Linux 2.6.27-rc8
Thread-Topic: Linux 2.6.27-rc8
Thread-Index: AckjCUH0Cqbou5QjSxeb5+7x8s1GZwACqHhg
Message-ID: <B27EBC40D200ED48A3F4CC2EBEABAE0B157C5019@orsmsx501.amr.corp.intel.com>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
 <Pine.LNX.4.64.0809300125460.2307@twin.jikos.cz>
 <alpine.LFD.2.00.0809291855000.3389@nehalem.linux-foundation.org>
 <alpine.LNX.1.10.0809300859590.4022@jikos.suse.cz>
 <m3d4ilk9n5.fsf@maximus.localdomain>
 <alpine.LNX.1.10.0809301610300.4022@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0809301610300.4022@jikos.suse.cz>
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

Ditto here, i.e. we have no similar reports on other parts.

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Jiri Kosina
Sent: Tuesday, September 30, 2008 7:11 AM
To: Krzysztof Halasa
Cc: Linus Torvalds; Linux Kernel Mailing List; Brandeburg, Jesse
Subject: Re: Linux 2.6.27-rc8

On Tue, 30 Sep 2008, Krzysztof Halasa wrote:

> > So far it seems to be that you need 1) something close to xorg 7.4 and
> > 2) 2.6.27-rcX kernel to trigger it. Not every system having e1000e is
> > affected.
> And this e1000e must be ICH*, right? I.e. not a separate e1000e
> chip/card?

So far all the affected systems I am aware of were ICH.

--
Jiri Kosina
SUSE Labs
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
