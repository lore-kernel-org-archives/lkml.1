Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZCLA5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZCLA5K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 20:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbZCLA4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 20:56:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:29501 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754043AbZCLA4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 20:56:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,346,1233561600"; 
   d="scan'208";a="497088952"
From: "Luo, Ximin" <ximin.luo@intel.com>
To: Nico Schottelius <nico-linux-ipw3945-devel@schottelius.org>
CC: "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       "Chatre, Reinette" <reinette.chatre@intel.com>,
       "Zhu, Yi" <yi.zhu@intel.com>
Date: Thu, 12 Mar 2009 08:56:10 +0800
Subject: RE: [ipw3945-devel] iwlagn: Cannot allocate memory on
	2.6.29-rc4-ikn-00001-gd5b5623
Thread-Topic: [ipw3945-devel] iwlagn: Cannot allocate memory on
	2.6.29-rc4-ikn-00001-gd5b5623
Thread-Index: AcmiODAsWxDaopfrTqyI7hEOhfHkywAcoUrA
Message-ID: <AFAB8585072C7E48BC5C6F9C87F9B7970733E7C4@pdsmsx502.ccr.corp.intel.com>
References: <20090309142407.GB18058@denkbrett.schottelius.org>
 <AFAB8585072C7E48BC5C6F9C87F9B797072E3362@pdsmsx502.ccr.corp.intel.com>
 <20090311105722.GB5471@denkbrett.schottelius.org>
In-Reply-To: <20090311105722.GB5471@denkbrett.schottelius.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n2C0vUqu019633

Hello Nico,

Thank you very much. :)
Could you please provide more details as comments of that bug, such as OS, uCode and kernel version? If you can easy reproduce it, please tell us the detailed steps to reproduce it? 
It will help our developer to tracking it. Thanks in advance.

Best Regards,
Ximin

-----Original Message-----
From: Nico Schottelius [mailto:nico-linux-ipw3945-devel@schottelius.org] 
Sent: 2009Äê3ÔÂ11ÈÕ 18:57
To: Luo, Ximin
Cc: ipw3945-devel@lists.sourceforge.net; LKML; Chatre, Reinette; Zhu, Yi
Subject: Re: [ipw3945-devel] iwlagn: Cannot allocate memory on 2.6.29-rc4-ikn-00001-gd5b5623

Luo, Ximin [Tue, Mar 10, 2009 at 09:05:02AM +0800]:
> Hello Nico,
> 
> This issue is caused by memory allocation failure when allocating rx memory in isr. (From Yi's point) If you are interested in tracking it, please report a bug at http://www.intellinuxwireless.org/bugzilla/ for further tracking.

http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1933

-- 
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
