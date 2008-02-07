Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbYBGMHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbYBGMHo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 07:07:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbYBGMHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 07:07:15 -0500
Received: from minas.ics.muni.cz ([147.251.4.40]:36054 "EHLO minas.ics.muni.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbYBGMHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 07:07:13 -0500
Date: Thu, 7 Feb 2008 13:06:55 +0100
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
To: linux-kernel@vger.kernel.org
Cc: jkosina@suse.cz, akpm@linux-foundation.org
Subject: Re: T61P sound issue
Message-ID: <20080207120655.GB10917@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-echelon: NSA, CIA, CI5, MI5, FBI, KGB, BIS, Plutonium, Bin Laden, bomb
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Muni-Spam-TestIP: 147.251.54.96
X-Muni-Envelope-From: xhejtman@anubis.fi.muni.cz
X-Muni-Virus-Test: Clean
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (minas.ics.muni.cz [147.251.4.35]); Thu, 07 Feb 2008 13:07:04 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have T61 and have no problem with sound. No sound problem could arise from
hw mute that is controlled via volume buttons. Volume mute does just mute (*no
unmute*!), buttons volume up/down unmutes volume.

There is bar "Speaker" in alsa mixer, must not be muted.

-- 
Luká¹ Hejtmánek
