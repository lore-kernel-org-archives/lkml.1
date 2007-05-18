Return-Path: <linux-kernel-owner+w=401wt.eu-S1760069AbXERGsD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760069AbXERGsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:48:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755029AbXERGry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:47:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58941 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977AbXERGrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:47:53 -0400
Subject: Re: [PATCH] LogFS take three
From: David Woodhouse <dwmw2@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Dongjun Shin <djshin90@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, Albert Cahalan <acahalan@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Greg KH <greg@kroah.com>,
       Ingo Oeser <ioe-lkml@rameria.de>
In-Reply-To: <Pine.LNX.4.61.0705180816430.3231@yvahk01.tjqt.qr>
References: <20070515151919.GA32510@lazybastard.org>
	 <20070515133759.9ee434a2.akpm@linux-foundation.org>
	 <1179317240.2859.222.camel@shinybook.infradead.org>
	 <20070516083408.dcd9dd78.akpm@linux-foundation.org>
	 <1179330596.2859.248.camel@shinybook.infradead.org>
	 <20070516164158.GB8113@lazybastard.org>
	 <7fe698080705162312t4e7ed90byd10ef8e664027b17@mail.gmail.com>
	 <1179383117.2859.416.camel@shinybook.infradead.org>
	 <7fe698080705170120w18fe5521oa685cf248a45e1c6@mail.gmail.com>
	 <20070517201847.GA5032@ucw.cz>
	 <7fe698080705171701w533767fdo6642bb772ed64273@mail.gmail.com>
	 <Pine.LNX.4.61.0705180816430.3231@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Fri, 18 May 2007 14:47:21 +0800
Message-Id: <1179470841.2859.550.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 08:17 +0200, Jan Engelhardt wrote:
> > AFAIK, the camera stops writing to the flash card and automatically
> > turns off when it's low on battery (before empty).
> 
> But then, one should also consider the case where a cam is connected to
> AC and someone inadvertently trips on the power cord. 

So you stick a bloody great cap on board to give you enough time to shut
it down cleanly. I've known people do this -- and it helps, but the
devices still manage to crap themselves occasionally even then.

They're _disposable_. As are your data :)

-- 
dwmw2

