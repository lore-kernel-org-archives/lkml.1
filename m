Return-Path: <linux-kernel-owner+w=401wt.eu-S1750782AbXB1Bef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbXB1Bef (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 20:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXB1Bef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 20:34:35 -0500
Received: from mail.tmr.com ([64.65.253.246]:53279 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbXB1Bef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 20:34:35 -0500
Message-ID: <45E4DC6B.9050305@tmr.com>
Date: Tue, 27 Feb 2007 20:35:39 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Andrew <andrew@nelless.net>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc1: framebuffer/console boot failure
References: <35472.86.7.220.119.1172237750.squirrel@wmbeta.mxes.net> <1172246719.3249.1.camel@localhost>
In-Reply-To: <1172246719.3249.1.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> I have just discovered 2.6.21-rc1 boots with
> pci=noacpi ...
> 
Try setting the resolution and frame rate, video=XXX:1280x1024@70 or 
such. Worked for me. I like pci=noacpi, though ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
