Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab0BVSPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:15:44 -0500
Received: from mail-yw0-f197.google.com ([209.85.211.197]:65064 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab0BVSPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:15:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OSaDvB+11WdZrUGrttp4reCUj+eshkUeu/tVs0zyu9va5hGe+rx7c0+1p73wuMKhWx
         GjYJ11NrIyVhxPOwzCkcXeVPhvJzAGdh+W8BlSgT8Wg8AOuzrlF6/XWXZleIQrtUyin8
         diuHpua7bwCZraALANhTdi+INnx4wh8GF92LQ=
Date: Mon, 22 Feb 2010 23:46:57 +0530
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 00/10] ARM: ftrace: cleanups, Thumb-2, and dynamic
 ftrace
Message-ID: <20100222181657.GA4102@debian>
References: <1266090518-31120-1-git-send-email-rabin@rab.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266090518-31120-1-git-send-email-rabin@rab.in>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven / Frederic / Ingo,

On Sun, Feb 14, 2010 at 01:18:28AM +0530, Rabin Vincent wrote:
> This series contains fixes and improvements to the ARM ftrace support.  It adds
> Thumb-2 support and re-implements the dynamic ftrace support.
> 
> "ftrace: allow building without frame pointers" and "ftrace: pass KBUILD_CFLAGS
> to record_mcount.pl" are non-ARM-specific ftrace patches which are required to
> support the ARM functionality.

Ping.  Any comments on this?

Rabin
