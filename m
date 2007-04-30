Return-Path: <linux-kernel-owner+w=401wt.eu-S1946584AbXD3Sfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946584AbXD3Sfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946593AbXD3Sfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:35:51 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:38839 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946588AbXD3Sfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:35:48 -0400
Date: Mon, 30 Apr 2007 20:29:49 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Uwe Bugla <uwe.bugla@gmx.de>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>, helge.hafting@aitel.hist.no,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Re: Critical points about kernel 2.6.21 and
 pseudo-authorities
In-Reply-To: <20070430172547.204810@gmx.net>
Message-ID: <Pine.LNX.4.61.0704302029220.29151@yvahk01.tjqt.qr>
References: <20070429182209.267430@gmx.net> 
 <alpine.LFD.0.98.0704291147530.9964@woody.linux-foundation.org> 
 <20070429205925.129920@gmx.net>  <alpine.LFD.0.98.0704291412500.9964@woody.linux-foundation.org>
  <20070429230037.95120@gmx.net> <1177894713.3046.5.camel@pc06.localdom.local>
 <20070430110255.267000@gmx.net> <4635D139.4030609@aitel.hist.no>
 <20070430115000.194060@gmx.net> <4636058B.3070603@aitel.hist.no>
 <Pine.LNX.4.64.0704301742390.2985@pentafluge.infradead.org>
 <20070430172547.204810@gmx.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	0.0 UPPERCASE_25_50        message body is 25-50% uppercase
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 30 2007 19:25, Uwe Bugla wrote:

>THIS PATCH IS DONE TO AVOID RAM WASTE FOR CASES IN WHICH IT IS PROVEN THAT DST
>AND DST_CA ARE NOT NEEDED AT ALL!!!!
>[...]


How much on the Theo-meter are we yet?


Jan
-- 
