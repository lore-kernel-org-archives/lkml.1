Return-Path: <linux-kernel-owner+w=401wt.eu-S1758191AbXELP7F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191AbXELP7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 11:59:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbXELP6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 11:58:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:22488 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXELP6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 11:58:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=QNCsb354Wvk3ODLmwASwrK+CpxljWm+9NJulh4TVED5GTQPpJmumx0h4Y2yVI6L6vWhHVoGb24Y4+6gxXgjIHnCKTBWRbWXw+sX6wVJ+P/dagl8OANmha7zY7zKGR/Cw20bV6Hr1y7Nxsm5p6z+DKATT88zFPkTqLhParSYBd5k=
Date: Sat, 12 May 2007 19:58:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.21-gitN - versioning question
Message-ID: <20070512155819.GA8366@cvg>
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
			^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
| >want that.
| >
| >I suppose I could put a tree on kernel.org which _does_ have the tags,
| >and which precisely matches Linus' tree in every other way... but then
| >again, you could do that too by just rsyncing the tags yourself :)
| 
| Are you saying GIT tags are expensive, compared to, say, SVN tags?
| 
| 
| 	Jan
| -- 
| 

Hi Jan,

you know the current Linus' git tree does contain ~62 tags
(if I'm right). And of coure that's very small number of files
compared to the number of blobs in the master tree. So I think the
reason to don't use a lot of tags - is just... well... a lot of
tags in the git tree ;)

[Don't beat me ;]

		Cyrill

