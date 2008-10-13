Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbYJMVWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbYJMVWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbYJMVWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:22:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:16785 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752528AbYJMVWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:22:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,405,1220252400"; 
   d="scan'208";a="626708103"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "jbarnes@virtuousgeek.org" <jbarnes@virtuousgeek.org>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 13 Oct 2008 14:17:55 -0700
Subject: RE: [PATCH] x86: split e820 reserved entries record to late v4 -
 fix v7
Thread-Topic: [PATCH] x86: split e820 reserved entries record to late v4 -
 fix v7
Thread-Index: AckteLXfB4zdF7kDTxSVsnmslZbfMgAAFpEg
Message-ID: <57C9024A16AD2D4C97DC78E552063EA353274483@orsmsx505.amr.corp.intel.com>
References: <1220254284-29532-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080904190457.GB24990@elte.hu>
	 <20080904121627.bc182da7.akpm@linux-foundation.org>
	 <86802c440809041222q244e1adaj16b80f1590053bcf@mail.gmail.com>
 <12c511ca0810131332h6e5468abk3dfc511f0b25cbe6@mail.gmail.com>
 <48F3BA28.2010605@zytor.com>
In-Reply-To: <48F3BA28.2010605@zytor.com>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha id m9DLMOdq015919

> Here is a fix... currently running standard tests on it.

That shuts up the compiler for the ia64 build.

Thanks

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
