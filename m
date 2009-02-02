Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZBBIeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZBBIeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 03:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZBBIeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 03:34:14 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:38966 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbZBBIeO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 03:34:14 -0500
Date: Mon, 2 Feb 2009 09:34:02 +0100
From: Pavel Machek <pavel@suse.cz>
To: Sriram V <vshrirama@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: SMC911X driver Suspend-Resume Failures
Message-ID: <20090202083402.GA3114@elf.ucw.cz>
References: <8bf247760901300435s56024125o9aae1a112196c9a1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bf247760901300435s56024125o9aae1a112196c9a1@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-01-30 18:05:27, Sriram V wrote:
> Hi,
>    I am using 2.6.28 and am testing PM on my arm target. I am using
> smc911x.c driver.
>    I get the error when i try to resume from suspend:
> 
>    has anyone seen this error before.

No, but try unloading the smc911 module and see if that repeats. Then
you can debug it with printk.



-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
