Return-Path: <linux-kernel-owner+w=401wt.eu-S1751708AbXA3TbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708AbXA3TbW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751711AbXA3TbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:31:22 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:43621 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbXA3TbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:31:21 -0500
Date: Tue, 30 Jan 2007 20:31:01 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
In-Reply-To: <20070130191405.GI20642@kroah.com>
Message-ID: <Pine.LNX.4.61.0701302028440.13737@yvahk01.tjqt.qr>
References: <20070130012904.GA9617@kroah.com> <Pine.LNX.4.61.0701301151350.23321@yvahk01.tjqt.qr>
 <20070130191405.GI20642@kroah.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 30 2007 11:14, Greg KH wrote:
>On Tue, Jan 30, 2007 at 11:52:48AM +0100, Jan Engelhardt wrote:
>> >This driver will work with all[1] of the different
>> >CPU types supported by Linux, the largest number of CPU types supported
>> >by any operating system ever before in the history of computing.
>> 
>> (How many do we support? How many does NetBSD?)
>
>We support at least 25 separate architectures, with a _huge_ variety of
>different variations within those architectures.  We passed NetBSD a
>number of years ago (sorry, don't have their numbers around right now.)

Don't they claim 50+? Already browsing 
ftp://ftp.de.netbsd.org/pub/NetBSD/NetBSD-3.1 gives more than 2 
screenfuls [à 25].


Jan
-- 
ft: http://freshmeat.net/p/chaostables/
