Return-Path: <linux-kernel-owner+w=401wt.eu-S1762421AbXKNS37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762421AbXKNS37 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 13:29:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756648AbXKNS3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 13:29:52 -0500
Received: from waste.org ([66.93.16.53]:51244 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbXKNS3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 13:29:52 -0500
Date: Wed, 14 Nov 2007 12:26:47 -0600
From: Matt Mackall <mpm@selenic.com>
To: "David P. Reed" <dpreed@reed.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Allessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH] x86: fix locking and sync bugs in x86_64 RTC code in time_64.c
Message-ID: <20071114182647.GA17536@waste.org>
References: <469578CD.3080609@reed.com> <1184216528.12353.203.camel@chaos> <1184218962.12353.209.camel@chaos> <46964352.7040301@reed.com> <1184253339.12353.223.camel@chaos> <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <47388586.7010509@reed.com> <alpine.LFD.0.9999.0711140826080.3265@localhost.localdomain> <473AF3BE.1010006@reed.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <473AF3BE.1010006@reed.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 08:10:22AM -0500, David P. Reed wrote:
> Will make two patches and resend.

I've already got a set of patches brewing to fix the UIP problem across all
the affected arches (11+).

-- 
Mathematics is the supreme nostalgia of our time.
