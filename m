Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbZJAOLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbZJAOLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932453AbZJAOLo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:11:44 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:21218 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932310AbZJAOLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:11:43 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Date: Thu, 1 Oct 2009 14:10:27 +0000
Subject: RE: [PATCH 07/34] move ilo_remove to .devexit.text
Thread-Topic: [PATCH 07/34] move ilo_remove to .devexit.text
Thread-Index: AcpCcVQOxLb1oBI4RQuEqQJTQzEODgAL1OLg
Message-ID: <92D64232F2316045B18937D5C9996B1522CD82DF6E@GVW1144EXB.americas.hpqcorp.net>
References: <20091001082607.GA2181@pengutronix.de>
 <1254385718-14254-7-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1254385718-14254-7-git-send-email-u.kleine-koenig@pengutronix.de>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n91ECf16014964


> The function ilo_remove is used only wrapped by __devexit_p so define it
> using __devexit.

Looks good to me.  Not sure if this is needed or not...

Acked-by: David Altobelli <david.altobelli@hp.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
