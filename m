Return-Path: <linux-kernel-owner+w=401wt.eu-S1759589AbZFZMuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589AbZFZMuN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:50:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758294AbZFZMuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:50:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:33792 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756758AbZFZMuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:50:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,296,1243839600"; 
   d="scan'208";a="469848718"
From: "Du, Alek" <alek.du@intel.com>
To: Jani Nikula <ext-jani.1.nikula@nokia.com>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "soni.trilok@gmail.com" <soni.trilok@gmail.com>,
       "ben-linux@fluff.org" <ben-linux@fluff.org>,
       "ext-phil.2.carmody@nokia.com" <ext-phil.2.carmody@nokia.com>
Date: Fri, 26 Jun 2009 20:50:00 +0800
Subject: RE: [PATCH 0/2] fix gpio-keys debouncing and timer sleep issues
Thread-Topic: [PATCH 0/2] fix gpio-keys debouncing and timer sleep issues
Thread-Index: Acn2V9LKME7nvlHYQGS8lTLf2tmVVAABBONg
Message-ID: <EADF0A36011179459010BDF5142A457501C9EE51CC@pdsmsx502.ccr.corp.intel.com>
References: <20090626002345.07928230@dxy.sh.intel.com>
 <cover.1246015395.git.ext-jani.1.nikula@nokia.com>
In-Reply-To: <cover.1246015395.git.ext-jani.1.nikula@nokia.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id n5QCp654032233

>From: Jani Nikula [mailto:ext-jani.1.nikula@nokia.com]
>Sent: 2009Äê6ÔÂ26ÈÕ 20:15
>To: Du, Alek
>Cc: dmitry.torokhov@gmail.com; linux-kernel@vger.kernel.org;
>linux-input@vger.kernel.org; soni.trilok@gmail.com; ben-linux@fluff.org;
>ext-phil.2.carmody@nokia.com; ext-jani.1.nikula@nokia.com
>Subject: [PATCH 0/2] fix gpio-keys debouncing and timer sleep issues
>
>Alek, someone might depend on how debouncing worked before, so let's not
>break it. I, for one, am looking at using this in the future, and would
>want this to work as it was before.
>
>Why don't we fix this instead of debating? For simplicity, here's first
>a revert of the original patch and then a fix to the sleep issue.
>Unfortunately, I do not have the equipment to properly test this right
>now.

Agree, and thanks for the patch.

>Could you please review and test this if you have the equipment? Add
>your signed-off-by and comments, of course. Would that be okay?

Ok, will test it later. And of course, we need Dmitry ACK it finally.

Alek

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
