Return-Path: <linux-kernel-owner+w=401wt.eu-S1755188AbXDZXNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188AbXDZXNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 19:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755189AbXDZXNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 19:13:12 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39383 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188AbXDZXNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 19:13:11 -0400
Message-ID: <463131FD.8020301@zytor.com>
Date: Thu, 26 Apr 2007 16:13:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Michael McConnell <soruk@eridani.co.uk>
CC: linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>
Subject: Re: MAINTAINERS file out of date?
References: <4631255F.9010902@eridani.co.uk>
In-Reply-To: <4631255F.9010902@eridani.co.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael McConnell wrote:
> Hi folks,
> 
> I noticed the MAINTAINERS file still lists Riley Williams as the
> maintainer of the i386 boot code, presumably as no-one else has taken it
> up in his absence (though, I'm sure it's probably been touched since
> late 2004).
> 
> If I knew the first thing about the i386 boot process I would volunteer,
> but sadly I don't....
> 
> This article below details the reason for his absence, but please make
> sure you're sitting down before clicking. (It is work-safe.)
> http://www.chorleytoday.co.uk/ViewArticle2.aspx?SectionID=81&ArticleID=905248
> 

Dear.

I have considered myself as a rather unofficial maintainer of this code,
and wouldn't mind make it official now when I actually have a job which
both cares about and actually can support my upstream Linux activities,
which was a major pain for a while.

Overall, there is a lot of cleanup which really is needed in the i386
boot process; I have done some work on it already, but more is needed.

	-hpa
