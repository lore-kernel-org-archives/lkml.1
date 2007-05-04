Return-Path: <linux-kernel-owner+w=401wt.eu-S1031391AbXEDRAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031391AbXEDRAv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 13:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031415AbXEDRAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 13:00:51 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:54865
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031391AbXEDRAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 13:00:50 -0400
Message-ID: <463B7534.6000207@microgate.com>
Date: Fri, 04 May 2007 12:02:28 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: Antonino Ingargiola <tritemio@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible
 bug]
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>	 <200705041049.20989.oliver@neukum.org>	 <5486cca80705040229g53933671m658bd028cadca155@mail.gmail.com>	 <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>	 <463B46F4.6090906@microgate.com> <463B4988.9090005@microgate.com>	 <1178290160.3913.2.camel@amdx2.microgate.com>	 <5486cca80705040904v786f13dh5614174fcc51c202@mail.gmail.com> <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
In-Reply-To: <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino Ingargiola wrote:
> The system blocks during booting. I can unblock it with SysReq+K but
> then I'm unable to log into X.

Hmmm, it tests here with no problem.

Does reversing the patch and rebuilding the kernel fix the boot?

-- 
Paul Fulghum
Microgate Systems, Ltd.
