Return-Path: <linux-kernel-owner+w=401wt.eu-S1758499AbXEMGoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499AbXEMGoQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755112AbXEMGoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:44:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:13952 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbXEMGoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:44:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=H9J9yboW9Egv9IofbpwxXjP+SN0FuKkpKRz74Uqx3LCjdW2XC6tOrOFigIKgHRMFDtzNKTQnWqRWxsS5Z+gc2eLsxLkQP3mq/d8cdYMPGEA4SNTL2c1OH/+KqCL+p2EagISB4ap3vdgwN+ZXyeXRWXxlPtPpAGToH+tpLwQKYII=
Date: Sun, 13 May 2007 10:43:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.21-gitN - versioning question
Message-ID: <20070513064325.GA8244@cvg>
References: <Pine.LNX.4.61.0705121316540.9570@yvahk01.tjqt.qr> <20070512.210308.93070730.yoshfuji@linux-ipv6.org> <20070512131906.GF8337@cvg> <1178977496.2802.5.camel@shinybook.infradead.org> <Pine.LNX.4.61.0705121701020.9570@yvahk01.tjqt.qr> <1179037601.2802.96.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179037601.2802.96.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[David Woodhouse - Sun, May 13, 2007 at 02:26:40PM +0800]
| On Sat, 2007-05-12 at 17:01 +0200, Jan Engelhardt wrote:
| > On May 12 2007 21:44, David Woodhouse wrote:
| > >On Sat, 2007-05-12 at 17:19 +0400, Cyrill Gorcunov wrote:
| > >> Actually I think it would be convenient if such tags (like
| > >> v.2.6.21-git16) were in Linus' git tree too.
| > >
| > >Then there would be _lots_ of tags in the master tree -- I'm not sure we
| > >want that.
| > >
| > >I suppose I could put a tree on kernel.org which _does_ have the tags,
| > >and which precisely matches Linus' tree in every other way... but then
| > >again, you could do that too by just rsyncing the tags yourself :)
| > 
| > Are you saying GIT tags are expensive, compared to, say, SVN tags?
| 
| I wasn't saying that -- I've no idea how expensive SVN tags are. But I
| was of the opinion that GIT tags aren't free -- I thought I'd seen
| git-pull explicitly checking (with one round-trip latency) that it has
| the corresponding commit for every tag it knows about.
| 
| -- 
| dwmw2
| 

Btw David who does release a such snapshots (like git16)? You or Linus?

		Cyrill

