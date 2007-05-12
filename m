Return-Path: <linux-kernel-owner+w=401wt.eu-S1757833AbXELHqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbXELHqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 03:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755547AbXELHqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 03:46:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46777 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755528AbXELHqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 03:46:07 -0400
Message-ID: <464570AC.5030108@garzik.org>
Date: Sat, 12 May 2007 03:45:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: jimmy bahuleyan <knight.camelot@gmail.com>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jonathan Corbet <corbet@lwn.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Johannes Stezenbach <js@linuxtv.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Heikki Orsila <shdl@zakalwe.fi>
Subject: Re: [PATCH] "volatile considered harmful", take 3
References: <12700.1178905000@lwn.net>	 <a781481a0705112021u7b6d32fcxb6318d7e2443c970@mail.gmail.com>	 <464551D5.2050709@zytor.com>	 <a781481a0705112315u5843abaar292859428ec60603@mail.gmail.com>	 <46455CD9.7010205@zytor.com> <a781481a0705120002xb604e7al629ceb1c27109451@mail.gmail.com> <46456B18.9060605@s5r6.in-berlin.de> <46456DDE.5070006@gmail.com>
In-Reply-To: <46456DDE.5070006@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

jimmy bahuleyan wrote:
> i believe, the doc here is pretty unambiguous regarding the fact that
> volatile should be avoided. And as Stefan pointed out, anyone who feels
> the need to use, must surely _know_ what he is doing & hence is in a
> position t make that decision

Honestly, the above quoted paragraph states the situation better than 
any long, complicated document.

	Jeff


