Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZHQJO7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZHQJO7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 05:14:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757548AbZHQJO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 05:14:58 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:5846 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757547AbZHQJO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 05:14:58 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAHO8iEpR9cbZ/2dsb2JhbADTVwmEEAWCKQ
Date: Mon, 17 Aug 2009 11:14:58 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Wan ZongShun <mcuos.com@gmail.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Add watchdog driver for w90p910
Message-ID: <20090817091458.GR4302@infomag.iguana.be>
References: <4A69CE00.10401@gmail.com> <20090804201032.GB30892@infomag.iguana.be> <e68bb3470908041955t7e07929bv612a25e0bc0264c1@mail.gmail.com> <20090805070822.GC30892@infomag.iguana.be> <e68bb3470908050100n4f6f8ed3hbd227a13e038e55f@mail.gmail.com> <20090805103127.GF30892@infomag.iguana.be> <4A79873A.5010504@gmail.com> <4A88C328.5040706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A88C328.5040706@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wan,

> At the same time, I renamed this driver name, due to I
> have changed the corresponding device name in my arch file.

Isn't it best to rename the driver in drivers/watchdog also to nuc900_wdt.c ?

Thanks,
Wim.

