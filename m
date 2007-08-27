Return-Path: <linux-kernel-owner+w=401wt.eu-S933950AbXH0VtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933950AbXH0VtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933492AbXH0VeI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:34:08 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:51669 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933484AbXH0VeH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:34:07 -0400
Date: Mon, 27 Aug 2007 23:34:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       Johannes Berg <johannes@sipsolutions.net>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH -mm 1/4] Hibernation: Arbitrary boot kernel support - generic code (rev. 2)
Message-ID: <20070827213430.GG3398@elf.ucw.cz>
References: <200708272331.28584.rjw@sisk.pl> <200708272333.44159.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708272333.44159.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2007-08-27 23:33:43, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Add the bits needed for supporting arbitrary boot kernels to the common
> hibernation code.
> 
> To support arbitrary boot kernels, make it possible to replace the 'struct
> new_utsname' and the kernel version in the hibernation image header by some
> architecture specific data that will be used to verify if the image is valid
> and to restore the image.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
