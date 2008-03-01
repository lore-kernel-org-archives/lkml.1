Return-Path: <linux-kernel-owner+w=401wt.eu-S1757438AbYCAPgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438AbYCAPgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2008 10:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbYCAPgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Mar 2008 10:36:11 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:38552 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbYCAPgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2008 10:36:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=PlEQvcgQCE5QQDHOI5FDX8ABXwwWbMl8Lay/yJsYBbrluvXEJJZf1uXpyXvSTktOXzZHcpeue7GrW6SUa7c2fPGcQpas7DHBW5tpXoPWuRauZI5CkM98p5lf9mqOEeRmWWF48sQ32UXMju89BwdU7tpeuOuyaAggluifW41wmiU=
Date: Sat, 1 Mar 2008 18:35:40 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: rth@twiddle.net, chris@zankel.net, linuxppc-dev@ozlabs.org,
       paulus@samba.org, dhowells@redhat.com, zippel@linux-m68k.org,
       geert@linux-m68k.org, linux-m68k@vger.kernel.org, takata@linux-m32r.org,
       linux-m32r@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Subject: Re: [RFC 08/10] um: dyn/uml.lds.S cleanup - use PAGE_SIZE macro
Message-ID: <20080301153540.GA7934@cvg>
References: <20080227205831.150784453@gmail.com> <20080227210004.189002678@gmail.com> <20080229154303.GC5886@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080229154303.GC5886@c2.user-mode-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jeff Dike - Fri, Feb 29, 2008 at 10:43:03AM -0500]
| On Wed, Feb 27, 2008 at 11:58:39PM +0300, gorcunov@gmail.com wrote:
| > This patch includes page.h header into liker scripts that
| > allow us to use PAGE_SIZE macro instead of numeric constant.
| > 
| > To be able to include page.h into linker scripts page.h is
| > needed for some modification - i.e. we need to use __ASSEMBLY__
| > and _AC macro
| > 
| > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| 
| Needed some fixing, but it's OK.  I'll forward it on.
| 
|        	    	    	Jeff
| 
| -- 
| Work email - jdike at linux dot intel dot com
| 

Thank you

		- Cyrill -
