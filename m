Return-Path: <linux-kernel-owner+w=401wt.eu-S1754107AbYITAUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbYITAUk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 20:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYITAUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 20:20:32 -0400
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:20789 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752796AbYITAUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 20:20:31 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6fcc8Vr6va+yAfnW87K6o48r+7vZ71nxP80H3EtRbZHHjER8YwQafpqRCdyLpMMWomWtJBJ1rmSs1yqta3QVCg4OUKeL81AdscKngkmIJURph2YKoSM5IYfdxHtv8VdMeRr1KQZruZdcaqg6IgVp2PMCg05MQs7+Rb81DTqP6VI=  ;
X-YMail-OSG: c1ZkG1sVM1mnNncLKfK7rHRWF5Kk5NiLS85YSIvHc2mpEPXzVKaYH6PNBZ7Dc9wGR5yQVXDyAn09vlkGqCkExOKLminuCYoyU5zllHyHWunUGaMyt_J2rKHO.cOc.kjAs66NkZfo
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Felipe Balbi <felipe.balbi@nokia.com>
Subject: Re: [PATCH 1/5] watchdog: sync linux-omap changes
Date: Fri, 19 Sep 2008 17:20:22 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
       Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com> <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
In-Reply-To: <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809191720.23375.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 19 September 2008, Felipe Balbi wrote:
> - * linux/drivers/char/watchdog/omap_wdt.c
> + * linux/drivers/watchdog/omap_wdt.c

current style omits the paths (just use "omap_wdt.c")
since they change periodically...

