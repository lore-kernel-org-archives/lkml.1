Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbXELOB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbXELOB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 10:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756752AbXELOBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 10:01:51 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:61631 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759234AbXELOBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 10:01:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=Ui2Lc+p2JAi/3vE7916JawOcFG9WnXTl/+usjXnUerr71oxgwXqFvnjWLPFU066frs5NvSTGDSlpbdT7tRPhtEOoYqbYT5whsFBMcdotnDcXdlBaSYtYmb8m9WSyT37P2/ZpWSEFcHFZYL0lDToKx05JppRz46lI+pXFxa2ms3o=
Date: Sat, 12 May 2007 18:01:16 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
       jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.21-gitN - versioning question
Message-ID: <20070512140116.GG8337@cvg>
References: <Pine.LNX.4.61.0705121316540.9570@yvahk01.tjqt.qr> <20070512.210308.93070730.yoshfuji@linux-ipv6.org> <20070512131906.GF8337@cvg> <1178977496.2802.5.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1178977496.2802.5.camel@shinybook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[David Woodhouse - Sat, May 12, 2007 at 09:44:56PM +0800]
| On Sat, 2007-05-12 at 17:19 +0400, Cyrill Gorcunov wrote:
| > Actually I think it would be convenient if such tags (like
| > v.2.6.21-git16) were in Linus' git tree too.
| 
| Then there would be _lots_ of tags in the master tree -- I'm not sure we
| want that.
| 
| I suppose I could put a tree on kernel.org which _does_ have the tags,
| and which precisely matches Linus' tree in every other way... but then
| again, you could do that too by just rsyncing the tags yourself :)
| 
| -- 
| dwmw2
| 

Hi David,

thanks for reply. Indeed ;) Leave all as it is.

		Cyrill

