Return-Path: <linux-kernel-owner+w=401wt.eu-S1759620AbXEPLav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759620AbXEPLav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 07:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756570AbXEPLao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 07:30:44 -0400
Received: from lazybastard.de ([212.112.238.170]:49421 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbXEPLan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 07:30:43 -0400
Date: Wed, 16 May 2007 13:09:34 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: John Stoffel <john@stoffel.org>, akpm@osdl.org,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Albert Cahalan <acahalan@gmail.com>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Ingo Oeser <ioe-lkml@rameria.de>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-mtd@lists.infradead.org,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-fsdevel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] LogFS take three
Message-ID: <20070516110933.GA5472@lazybastard.org>
References: <20070515151919.GA32510@lazybastard.org> <17994.1241.436841.681216@stoffel.org> <20070515191926.GB1220@lazybastard.org> <1179291255.2859.195.camel@shinybook.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1179291255.2859.195.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 12:54:14 +0800, David Woodhouse wrote:
> 
> Personally I'd just go for 'JFFS3'. After all, it has a better claim to
> the name than either of its predecessors :)

Did you ever see akpm's facial expression when he tried to pronounce
"JFFS2"?  ;)

Jörn

-- 
Fancy algorithms are slow when n is small, and n is usually small.
Fancy algorithms have big constants. Until you know that n is
frequently going to be big, don't get fancy.
-- Rob Pike
