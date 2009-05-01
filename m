Return-Path: <linux-kernel-owner+w=401wt.eu-S1762638AbZEAWjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762638AbZEAWjf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 18:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760947AbZEAWjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 18:39:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:1925 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756042AbZEAWjY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 18:39:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,280,1239001200"; 
   d="scan'208";a="408761971"
From: "Luck, Tony" <tony.luck@intel.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 1 May 2009 15:39:23 -0700
Subject: RE: "N" symbols and System.map
Thread-Topic: "N" symbols and System.map
Thread-Index: AcnKq5nDoAyZ4bgRRjaT80d2nOgirgAAegHw
Message-ID: <57C9024A16AD2D4C97DC78E552063EA39EF46B91@orsmsx505.amr.corp.intel.com>
References: <49FB7692.2000508@linux.intel.com>
In-Reply-To: <49FB7692.2000508@linux.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n41Mddqu017394

> Are there other architectures which would suffer if N were included in
> System.map, or would that be a reasonable thing to do?

ia64 has no "N" symbols.  _end shows up as an "A" for me.

-Tony
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
