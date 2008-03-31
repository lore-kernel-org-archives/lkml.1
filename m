Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbYCaOFZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbYCaOFZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:05:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYCaOFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:05:15 -0400
Received: from smtp.nokia.com ([192.100.105.134]:39365 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbYCaOFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:05:13 -0400
Message-ID: <47F0EE63.3060401@nokia.com>
Date: Mon, 31 Mar 2008 17:00:03 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: =?UTF-8?B?SsO2cm4gRW5nZWw=?= <joern@logfs.org>
CC: Adrian Hunter <ext-adrian.hunter@nokia.com>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       LKML <linux-kernel@vger.kernel.org>, joern@lazybastard.org
Subject: Re: [RFC PATCH] UBIFS - new flash file system
References: <1206629746-4298-1-git-send-email-Artem.Bityutskiy@nokia.com> <alpine.LNX.1.10.0803311428270.2554@fbirervta.pbzchgretzou.qr> <47F0DD49.7010302@nokia.com> <20080331132047.GA31660@logfs.org>
In-Reply-To: <20080331132047.GA31660@logfs.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 31 Mar 2008 14:03:42.0553 (UTC) FILETIME=[0708D490:01C89338]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jörn Engel wrote:
>> 3. logfs does not seem to have bad-block handling.
> 
> Bad blocks at mkfs time are handled, blocks turning bad later on aren't
> yet.

I personally refuse to compare a finished FS with handles all the
crucial flash features to a non-finished FS. It just makes no sense.

LogFS was talked about back 2005 in Linux Kongress [1], but is not
finished yet. Let's talk about it when it is production ready.

[1]. http://www.linux-kongress.org/2005/abstracts.html#4_4_2

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
