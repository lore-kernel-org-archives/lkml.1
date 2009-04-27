Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbZD0Svz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbZD0Svz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 14:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbZD0Svq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 14:51:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:19292 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbZD0Svp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 14:51:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,255,1239001200"; 
   d="scan'208";a="451884104"
From: "Styner, Douglas W" <douglas.w.styner@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
       "Ma, Chinang" <chinang.ma@intel.com>,
       "willy@linux.intel.com" <willy@linux.intel.com>
Date: Mon, 27 Apr 2009 11:51:30 -0700
Subject: RE: Discrepancies between Oprofile and vmstat II
Thread-Topic: Discrepancies between Oprofile and vmstat II
Thread-Index: AcnHaNl8mh9jTQZWQwiviW/3Ovq4EgAAB/pw
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459872B2@azsmsx501.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345836A3A@azsmsx501.amr.corp.intel.com>
 <87ljpmk29b.fsf@basil.nowhere.org>
 <D7C42C27E6CB1E4D8CBDF2F81EA92A26034598724F@azsmsx501.amr.corp.intel.com>
 <20090427185305.GG27382@one.firstfloor.org>
In-Reply-To: <20090427185305.GG27382@one.firstfloor.org>
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

I believe so, but will confirm.

> opcontrol -e=CPU_CLK_UNHALTED:80000 -e=LLC_MISSES:6000
> 
> Using another profiling tool to confirm, we see 74.784% user, 25.174% kernel.

Just verifying -- you also see it when you use a shorter period than 80000 right?


