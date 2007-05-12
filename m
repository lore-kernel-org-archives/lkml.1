Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbXELQZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbXELQZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754528AbXELQZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:25:10 -0400
Received: from ik-out-1112.google.com ([66.249.90.178]:57019 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbXELQZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:25:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QA8KSUNWH0VC9vEqe5fToTWxaG3dR8Zm0cZiVfImHV7kclLGnL+nNKdFPaWMLcvXDbKgFqVJSVj1Z/C4CPn4EwI/imDQmQwh//OLlRu6YnCliYxAzZChp1dw1juvjhxi/tzfHpdg9olUKx9JnYkdX2A2z5Tn5qHfqOCBey/BRb0=
Date: Sat, 12 May 2007 20:24:28 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.21-gitN - versioning question
Message-ID: <20070512162428.GB8366@cvg>
References: <Pine.LNX.4.61.0705121316540.9570@yvahk01.tjqt.qr> <20070512.210308.93070730.yoshfuji@linux-ipv6.org> <20070512131906.GF8337@cvg> <1178977496.2802.5.camel@shinybook.infradead.org> <Pine.LNX.4.61.0705121701020.9570@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705121701020.9570@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Jan Engelhardt - Sat, May 12, 2007 at 05:01:19PM +0200]
| 
| On May 12 2007 21:44, David Woodhouse wrote:
| >On Sat, 2007-05-12 at 17:19 +0400, Cyrill Gorcunov wrote:
| >> Actually I think it would be convenient if such tags (like
| >> v.2.6.21-git16) were in Linus' git tree too.
| >
| >Then there would be _lots_ of tags in the master tree -- I'm not sure we
| >want that.
| >
| >I suppose I could put a tree on kernel.org which _does_ have the tags,
| >and which precisely matches Linus' tree in every other way... but then
| >again, you could do that too by just rsyncing the tags yourself :)
| 
| Are you saying GIT tags are expensive, compared to, say, SVN tags?
| 

Anyway, Davind wrote that he could put a special tree with tags on
kernel.org. And we always have opportunity to make a such tags
in our own tree copies by hands. But I prefer keep (on my computer)
pure Linus' git tree clone ;)

		Cyrill

