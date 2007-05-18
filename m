Return-Path: <linux-kernel-owner+w=401wt.eu-S1761550AbXERGl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761550AbXERGl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754977AbXERGlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:41:19 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:53573 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754564AbXERGlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:41:18 -0400
Date: Fri, 18 May 2007 08:17:30 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Dongjun Shin <djshin90@gmail.com>
cc: Pavel Machek <pavel@ucw.cz>, David Woodhouse <dwmw2@infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@lazybastard.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
Subject: Re: [PATCH] LogFS take three
In-Reply-To: <7fe698080705171701w533767fdo6642bb772ed64273@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0705180816430.3231@yvahk01.tjqt.qr>
References: <20070515151919.GA32510@lazybastard.org> 
 <20070515133759.9ee434a2.akpm@linux-foundation.org> 
 <1179317240.2859.222.camel@shinybook.infradead.org> 
 <20070516083408.dcd9dd78.akpm@linux-foundation.org> 
 <1179330596.2859.248.camel@shinybook.infradead.org>  <20070516164158.GB8113@lazybastard.org>
  <7fe698080705162312t4e7ed90byd10ef8e664027b17@mail.gmail.com> 
 <1179383117.2859.416.camel@shinybook.infradead.org> 
 <7fe698080705170120w18fe5521oa685cf248a45e1c6@mail.gmail.com> 
 <20070517201847.GA5032@ucw.cz> <7fe698080705171701w533767fdo6642bb772ed64273@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18 2007 09:01, Dongjun Shin wrote:
> On 5/18/07, Pavel Machek <pavel@ucw.cz> wrote:
>> 
>> Hmm.. so operating your camera on batteries should be against the
>> warranty, since batteries commonly run empty while storing pictures?
>
> AFAIK, the camera stops writing to the flash card and automatically
> turns off when it's low on battery (before empty).

But then, one should also consider the case where a cam is connected to
AC and someone inadvertently trips on the power cord.


	Jan
-- 
