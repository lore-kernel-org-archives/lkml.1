Return-Path: <linux-kernel-owner+w=401wt.eu-S1752578AbYHRGuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbYHRGuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 02:50:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750924AbYHRGuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 02:50:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46528 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbYHRGt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 02:49:59 -0400
Message-ID: <48A91A9B.7030001@zytor.com>
Date: Sun, 17 Aug 2008 23:45:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: David Fries <david@fries.net>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu>
In-Reply-To: <20080818064120.GA28941@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> applied to tip/x86/urgent, thanks David. I've changed the conditions to 
> read_cr4_safe() instead - that's cleaner. Could you please check whether 
> the patch below works fine too on your box?
> 
> Rafael, Pavel - does the commit below look good to you too?
> 

Looks good to me.

	-hpa
