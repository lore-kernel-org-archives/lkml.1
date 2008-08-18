Return-Path: <linux-kernel-owner+w=401wt.eu-S1757162AbYHRWBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162AbYHRWBe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 18:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753549AbYHRWBY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 18:01:24 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:44831 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753282AbYHRWBX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 18:01:23 -0400
Date: Tue, 19 Aug 2008 00:02:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       David Fries <david@fries.net>, linux-kernel@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Fix i486 suspend to disk CR4 oops
Message-ID: <20080818220235.GA2053@elf.ucw.cz>
References: <20080818040340.GB17528@spacedout.fries.net> <20080818064120.GA28941@elte.hu> <20080818152440.GA26134@redhat.com> <48A9B228.3040504@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A9B228.3040504@zytor.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2008-08-18 10:32:24, H. Peter Anvin wrote:
> Dave Jones wrote:
>>
>> Is this part really necessary ?
>>
>> Why would a 486 be in EFI code?
>>
>
> Necessary, almost certainly not, but (a) it doesn't hurt anything, (b) it's 
> good to be consistent and (c) it might still be useful to virtualizers.

...it may be useful for something obscure... like system-on-chip...
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
