Return-Path: <linux-kernel-owner+w=401wt.eu-S1751333AbXEXOEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbXEXOEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbXEXOEV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:04:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:35582 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbXEXOEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:04:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=ZlScbOThSgwFnxNtzn2G5An34bXco7xKdrQ1vR5xnYfLNhY/Sn3QIbzTkXHkWNv6dPczsekUCnEugHNfYnHZSzAIEvQabWXS/iLpmQtFv8xVOp4D4TzeDIQCavsVj3kum8RA1s3cCiuzt14KFap5+U/wR0kmvN+3MaS+4ycjfCA=
Message-ID: <46559B5B.4060508@googlemail.com>
Date: Thu, 24 May 2007 16:04:11 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net,
       "art@usfltd.com" <art@usfltd.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Hans Verkuil <hverkuil@xs4all.nl>, Robert Fitzsimons <robfitz@273k.net>
Subject: Re: [3/3] 2.6.22-rc2: known regressions v2
References: <46558708.2040803@googlemail.com>
In-Reply-To: <46558708.2040803@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc2.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



USB

Subject    : usb hotplug/udev cannot correctly register usb/scanners
References : http://lkml.org/lkml/2007/5/15/205
Submitter  : art@usfltd.com <art@usfltd.com>
Status     : Unknown



V4L

Subject    : V4L ABI breakage
References : http://lkml.org/lkml/2007/5/14/42
Submitter  : Robert Fitzsimons <robfitz@273k.net>
Caused-By  : Hans Verkuil <hverkuil@xs4all.nl>
             Mauro Carvalho Chehab <mchehab@infradead.org>
             commit 206ebaf32795cf1582b1e2ff2ec6a560c9e986b8
Workaround : http://git.kernel.org/?p=linux/kernel/git/mchehab/v4l-dvb.git;a=commitdiff;h=15ac2d293b08b6975c6ca1a80eb839d4cb0dddbf
Status     : problem is being debugged



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"

