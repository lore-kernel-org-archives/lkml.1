Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbXELPDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbXELPDS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbXELPDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:03:06 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58032 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755673AbXELPDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:03:05 -0400
Date: Sat, 12 May 2007 17:01:19 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: David Woodhouse <dwmw2@infradead.org>
cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.21-gitN - versioning question
In-Reply-To: <1178977496.2802.5.camel@shinybook.infradead.org>
Message-ID: <Pine.LNX.4.61.0705121701020.9570@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0705121316540.9570@yvahk01.tjqt.qr> 
 <20070512.210308.93070730.yoshfuji@linux-ipv6.org>  <20070512131906.GF8337@cvg>
 <1178977496.2802.5.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 12 2007 21:44, David Woodhouse wrote:
>On Sat, 2007-05-12 at 17:19 +0400, Cyrill Gorcunov wrote:
>> Actually I think it would be convenient if such tags (like
>> v.2.6.21-git16) were in Linus' git tree too.
>
>Then there would be _lots_ of tags in the master tree -- I'm not sure we
>want that.
>
>I suppose I could put a tree on kernel.org which _does_ have the tags,
>and which precisely matches Linus' tree in every other way... but then
>again, you could do that too by just rsyncing the tags yourself :)

Are you saying GIT tags are expensive, compared to, say, SVN tags?


	Jan
-- 
