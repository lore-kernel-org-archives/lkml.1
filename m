Return-Path: <linux-kernel-owner+w=401wt.eu-S1762200AbXEKVro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762200AbXEKVro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 17:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755477AbXEKVrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 17:47:36 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39452 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555AbXEKVrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 17:47:35 -0400
Message-ID: <4644E469.8000603@zytor.com>
Date: Fri, 11 May 2007 14:47:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>,
       Satyam Sharma <satyam.sharma@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 2
References: <6143.1178828419@lwn.net> <Pine.LNX.4.61.0705102326470.6426@yvahk01.tjqt.qr> <46439284.6080901@zytor.com> <Pine.LNX.4.61.0705112333320.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705112333320.9570@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
>>>
>>> turns up no less than 1106+2 hits.
>> You forgot to exclude instances with "asm" in them.
> 
> You can do that.
> 

I can.  54.2% of those hits were "asm", and therefore require the
"register" keyword.

	-hpa
