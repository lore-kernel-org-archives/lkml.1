Return-Path: <linux-kernel-owner+w=401wt.eu-S1754154AbYHRQEk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbYHRQEk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 12:04:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752727AbYHRQEc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 12:04:32 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:43710 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752031AbYHRQEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 12:04:32 -0400
Date: Mon, 18 Aug 2008 12:04:26 -0400
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       David Fries <david@fries.net>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
Message-ID: <20080818160426.GD12476@csclub.uwaterloo.ca>
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu> <20080818152440.GA26134@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818152440.GA26134@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 11:24:40AM -0400, Dave Jones wrote:
> Is this part really necessary ?
> 
> Why would a 486 be in EFI code?

Someone has a hobby writing replacement firmware for their 486?

-- 
Len Sorensen
