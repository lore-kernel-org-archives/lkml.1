Return-Path: <linux-kernel-owner+w=401wt.eu-S1759812AbZBER7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759812AbZBER7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:59:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZBER6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:58:52 -0500
Received: from sycorax.lbl.gov ([128.3.11.121]:46274 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbZBER6v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:58:51 -0500
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Takashi Iwai <tiwai@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc3: weird process after resume
References: <878womf727.fsf@sycorax.lbl.gov>
	<20090204153954.844ac67b.akpm@linux-foundation.org>
	<87hc39ejx2.fsf@sycorax.lbl.gov>
	<20090204183142.11e6f661.akpm@linux-foundation.org>
	<20090204185645.bb9d86b2.akpm@linux-foundation.org>
	<s5h3aet8joa.wl%tiwai@suse.de>
Date: Thu, 05 Feb 2009 09:58:15 -0800
In-Reply-To: <s5h3aet8joa.wl%tiwai@suse.de> (message from Takashi Iwai on Thu,
	05 Feb 2009 07:47:01 +0100)
Message-ID: <871vuc3gw8.fsf@sycorax.lbl.gov>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> writes:

> Alex, could you try the patch below?  It's now in sound git tree:
>    git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6.git

the patch seems to work. there is now only one kernel process named
hd-audio and it keeps its name after suspending to memory. thanks.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
