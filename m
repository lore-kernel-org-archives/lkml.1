Return-Path: <linux-kernel-owner+w=401wt.eu-S2992656AbXCBRZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992656AbXCBRZP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 12:25:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992659AbXCBRZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 12:25:15 -0500
Received: from sycorax.lbl.gov ([128.3.11.121]:3146 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992657AbXCBRZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 12:25:12 -0500
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: 2.6.21-rc2 radeon backlight
References: <87ps7uutsk.fsf@sycorax.lbl.gov>
	<20070301184531.b3aeafe3.akpm@linux-foundation.org>
Date: Fri, 02 Mar 2007 09:24:03 -0800
In-Reply-To: <20070301184531.b3aeafe3.akpm@linux-foundation.org> (message from
	Andrew Morton on Thu, 1 Mar 2007 18:45:31 -0800)
Message-ID: <87tzx35zkc.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:

> On Wed, 28 Feb 2007 08:32:43 -0800
> Alex Romosan <romosan@sycorax.lbl.gov> wrote:
>
>> the backlight on my thinkpad still (2.6.20 worked fine) doesn't come
>> on if i have the radeon backlight enabled. without it, i guess it's
>> the ibm acpi modules that controls the backlight and it seems to work
>> fine.
>> 
>
> Unclear. Are you saying that the backlight comes on OK if you use
> the IBM acpi module?

yes, if i disable the radeon backlight and use the ibm acpi module,
than the backlight works. if i enable the radeon backlight, the screen
stays dark and i can't turn it on (i tried using radeontool to control
it but nothing happened).

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
