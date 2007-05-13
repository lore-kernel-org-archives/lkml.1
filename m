Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbXEMG0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbXEMG0x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXEMG0r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:26:47 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60512 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbXEMG0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:26:46 -0400
Subject: Re: linux-2.6.21-gitN - versioning question
From: David Woodhouse <dwmw2@infradead.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.61.0705121701020.9570@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705121316540.9570@yvahk01.tjqt.qr>
	 <20070512.210308.93070730.yoshfuji@linux-ipv6.org>
	 <20070512131906.GF8337@cvg>
	 <1178977496.2802.5.camel@shinybook.infradead.org>
	 <Pine.LNX.4.61.0705121701020.9570@yvahk01.tjqt.qr>
Content-Type: text/plain
Date: Sun, 13 May 2007 14:26:40 +0800
Message-Id: <1179037601.2802.96.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.dwmw2.2) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-05-12 at 17:01 +0200, Jan Engelhardt wrote:
> On May 12 2007 21:44, David Woodhouse wrote:
> >On Sat, 2007-05-12 at 17:19 +0400, Cyrill Gorcunov wrote:
> >> Actually I think it would be convenient if such tags (like
> >> v.2.6.21-git16) were in Linus' git tree too.
> >
> >Then there would be _lots_ of tags in the master tree -- I'm not sure we
> >want that.
> >
> >I suppose I could put a tree on kernel.org which _does_ have the tags,
> >and which precisely matches Linus' tree in every other way... but then
> >again, you could do that too by just rsyncing the tags yourself :)
> 
> Are you saying GIT tags are expensive, compared to, say, SVN tags?

I wasn't saying that -- I've no idea how expensive SVN tags are. But I
was of the opinion that GIT tags aren't free -- I thought I'd seen
git-pull explicitly checking (with one round-trip latency) that it has
the corresponding commit for every tag it knows about.

-- 
dwmw2

