Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbZLJOVu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbZLJOVu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 09:21:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751334AbZLJOVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 09:21:45 -0500
Received: from smtp.nokia.com ([192.100.122.230]:56313 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbZLJOVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 09:21:44 -0500
Date: Thu, 10 Dec 2009 16:21:27 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
       "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091210142127.GB12526@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <20091202204946.GB25682@nokia.com>
 <6ed0b2680912021329g372bd0a4vb5b4a80244960f95@mail.gmail.com>
 <20091202215442.GA30658@oksana.dev.rtsoft.ru>
 <20091202223156.GA14921@nokia.com>
 <20091202225922.GA15568@oksana.dev.rtsoft.ru>
 <20091203083958.GB31110@nokia.com>
 <6ed0b2680912030255o57d7c46qb5ae1cfcb82e9976@mail.gmail.com>
 <20091203110332.GO1361@nokia.com>
 <6ed0b2680912100609g11706296qdbcea887dc3a5733@mail.gmail.com>
 <20091210141830.GA10687@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091210141830.GA10687@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 10 Dec 2009 14:21:30.0586 (UTC) FILETIME=[1154FBA0:01CA79A4]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Dec 10, 2009 at 03:18:30PM +0100, ext Anton Vorontsov wrote:
>> Ok since it doesn't look like this will resolve soon, what about
>> adding some DEVICE_ATTR for the time being and requiring userspace to
>> write charge current here to start actual charging?
>
>Works for me. Let's think of the kernel charging support as an
>yet unimplemented feature.

but if you guys are ok with this one for now. It can always be changed 
later :-)

-- 
balbi
