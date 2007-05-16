Return-Path: <linux-kernel-owner+w=401wt.eu-S1762157AbXEPEyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762157AbXEPEyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 00:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbXEPEym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 00:54:42 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38843 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758612AbXEPEyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 00:54:41 -0400
Subject: Re: [PATCH] LogFS take three
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Cc: John Stoffel <john@stoffel.org>, akpm@osdl.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Ingo Oeser <ioe-lkml@rameria.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mtd@lists.infradead.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070515191926.GB1220@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org>
	 <17994.1241.436841.681216@stoffel.org>
	 <20070515191926.GB1220@lazybastard.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 16 May 2007 12:54:14 +0800
Message-Id: <1179291255.2859.195.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-15 at 21:19 +0200, Jörn Engel wrote:
> On Tue, 15 May 2007 15:07:05 -0400, John Stoffel wrote:
> > 
> > I've been semi watching this, and the only comment I really can give
> > is that I hate the name.  To me, logfs implies a filesystem for
> > logging purposes, not for Flash hardware with wear leveling issues to
> > be taken into account.
> 
> Yeah, well, ...
> 
> Two years ago when I started all this, I was looking for a good name.
> All I could come up with sounded stupid, so I picked "LogFS" as a code
> name.  As soon as I find a better name, the code name should get
> replaced.
> 
> By now I still don't have anything better.  All alternatives that were
> proposed are just as bad - with the added disadvantage of being new and
> not established yet.  My hope of ever finding a better name is nearly
> zero. 

Personally I'd just go for 'JFFS3'. After all, it has a better claim to
the name than either of its predecessors :)

-- 
dwmw2

