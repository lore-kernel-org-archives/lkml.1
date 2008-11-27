Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYK0Qnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYK0Qnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 11:43:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751868AbYK0QnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 11:43:24 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:39207 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751448AbYK0QnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 11:43:24 -0500
Date: Thu, 27 Nov 2008 11:43:23 -0500
To: Rodolfo Giometti <giometti@linux.it>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: LinuxPPS (Version 10): the PPS Linux implementation.
Message-ID: <20081127164323.GI5682@csclub.uwaterloo.ca>
References: <1227706969-20003-1-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1227706969-20003-1-git-send-email-giometti@linux.it>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 02:42:40PM +0100, Rodolfo Giometti wrote:
> Note: Very few changes since last post! Please, add this patch set
>       into next available merge window.
> 
> This patch set adds the PPS support into Linux.
> 
> PPS means "pulse per second" and its API is specified by RFC 2783
> (Pulse-Per-Second API for UNIX-like Operating Systems, Version 1.0).
> 
> The code has been tested with the NTPD program
> (http://www.eecis.udel.edu/~mills/ntp/html/index.html) and several GPS
> antennae.

Yay!  Thank you for still working on this.  I am using 5.3.1 at the
moment on 2.6.26 (was using 3.0.0 for a long time on 2.6.18) and so far
things are great.

-- 
Len Sorensen
