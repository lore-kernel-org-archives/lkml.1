Return-Path: <linux-kernel-owner+w=401wt.eu-S1757742AbXELNTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742AbXELNTr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 09:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756713AbXELNTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 09:19:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:28675 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756655AbXELNTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 09:19:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UnR9ftopIiX/ykEXgaa+mUszzmnOb7+3klbASfQpQAEiQ14GTXvkkqeYxFHYc0Co3p28O0E9mHg8gbpSSvnsG/ltAzKduE5n4HcHUPt/z+2B+yAThNcPhkdEOv9CX5ktrCpDSPU0ferXRY6J5UKwDas2mNxSdmVIEo82IQrxRe0=
Date: Sat, 12 May 2007 17:19:06 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>
Cc: jengelh@linux01.gwdg.de, linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.21-gitN - versioning question
Message-ID: <20070512131906.GF8337@cvg>
References: <Pine.LNX.4.61.0705121316540.9570@yvahk01.tjqt.qr> <20070512.210308.93070730.yoshfuji@linux-ipv6.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070512.210308.93070730.yoshfuji@linux-ipv6.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[YOSHIFUJI Hideaki / ?$B5HF#1QL@ - Sat, May 12, 2007 at 09:03:08PM +0900]
| In article <Pine.LNX.4.61.0705121316540.9570@yvahk01.tjqt.qr> (at Sat, 12 May 2007 13:19:23 +0200 (MEST)), Jan Engelhardt <jengelh@linux01.gwdg.de> says:
| 
| > I notice that people refer to certain git snapshots as e.g. -git16; 
| > kernel.org does so too. Hovering over the link on kernel.org reveals 
| > http://kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.21-git16.bz2
| > but where do I actually find -git16 in Linus's git tree? git16 is 
| > neither a branch nor a tag.
| 
| http://kernel.org/pub/linux/kernel/v2.6/snapshots/patch-2.6.21-git16.id
| tells the commit in his tree.
| 
| --yoshfuji

Actually I think it would be convenient if such tags (like v.2.6.21-git16)
were in Linus' git tree too.


		Cyrill

