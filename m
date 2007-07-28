Return-Path: <linux-kernel-owner+w=401wt.eu-S1758586AbXG1WfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586AbXG1WfW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 18:35:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757353AbXG1WfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 18:35:11 -0400
Received: from main.gmane.org ([80.91.229.2]:44536 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757318AbXG1WfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 18:35:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alex Besogonov <cyberax@elewise.com>
Subject: Re: [ck] Re: Linus 2.6.23-rc1
Date: Sun, 29 Jul 2007 01:16:20 +0300
Message-ID: <f8gf7v$o89$1@sea.gmane.org>
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <1185588279.1654.1.camel@localhost> <alpine.LFD.0.999.0707271922050.3442@woody.linux-foundation.org> <Pine.LNX.4.63.0707280817540.27758@alpha.polcom.net> <954c7c800707280045t4607cebfj532ef025a7a57c05@mail.gmail.com> <alpine.LFD.0.999.0707280956140.3442@woody.linux-foundation.org> <Pine.LNX.4.64.0707281927500.15125@fbirervta.pbzchgretzou.qr> <alpine.LFD.0.999.0707281050590.3442@woody.linux-foundation.org> <20070728225148.a0e58fdd.diegocg@gmail.com> <alpine.LFD.0.999.0707281401280.3442@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: ip.82.144.205.104.stat-3.volia.net
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
In-Reply-To: <alpine.LFD.0.999.0707281401280.3442@woody.linux-foundation.org>
Cc: ck@vds.kolivas.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> I personally feel that modal behaviour is bad, so it would introduce what 
> is in my opinion bad code, and likely result in problems not being found 
> and fixed as well (because people would pick the thing that "works for 
> them", and ignore the problems in the other module). 
I'm sorry, but this argument doesn't hold water. It was invoked years 
ago and turned out to be incorrect - the new CFS scheduler is not just a
fixed old scheduler, it's a completely redesigned one.

-- 
With respect,
             Alex Besogonov (cyberax@elewise.com)

