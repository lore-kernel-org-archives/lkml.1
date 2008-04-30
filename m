Return-Path: <linux-kernel-owner+w=401wt.eu-S932748AbYD3Trm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748AbYD3Trm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932601AbYD3TrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:47:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57763 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932597AbYD3TrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:47:16 -0400
Date: Wed, 30 Apr 2008 12:46:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gabriel C <nix.or.die@googlemail.com>
Cc: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH] iTCO_wdt: ICH9DO support
Message-Id: <20080430124642.bcba1673.akpm@linux-foundation.org>
In-Reply-To: <4818B963.7000108@googlemail.com>
References: <4818875E.7020703@googlemail.com>
	<20080430111508.2dc5b26c.akpm@linux-foundation.org>
	<4818B963.7000108@googlemail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 20:24:35 +0200
Gabriel C <nix.or.die@googlemail.com> wrote:

> Andrew Morton wrote:
> > On Wed, 30 Apr 2008 16:51:10 +0200
> > Gabriel C <nix.or.die@googlemail.com> wrote:
> > 
> >> -#define DRV_VERSION     "1.02"
> >> -#define DRV_RELDATE     "26-Jul-2007"
> >> +#define DRV_VERSION     "1.03"
> >> +#define DRV_RELDATE     "30-Apr-2008"
> > 
> > lol.  git-watchdog changes these to
> > 
> > #define DRV_VERSION     "1.10"
> > #define DRV_RELDATE     "17-Aug-2007"
> > 
> > Version numbers and dates like this really are pretty pointless.  If you
> > get a report against "v1.10", it just is not useful information.  You still
> > need to ask "what kernel version" to be able to reliably locate the source
> > for the reporter's driver.
> > 
> > 
> > But it's a great way to generate .rej files.
> 
> Really sorry Andrew here the patch without the changes to the driver version.
> 

Is OK, I already fixed it (as you saw).

There's nothing to be sorry about - it's not your fault.  My email can be
summarised down to "Hey, Wim: remove that crap!".

