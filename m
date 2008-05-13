Return-Path: <linux-kernel-owner+w=401wt.eu-S1758664AbYEMJ1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758664AbYEMJ1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 05:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750790AbYEMJ11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 05:27:27 -0400
Received: from styx.suse.cz ([82.119.242.94]:59134 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750788AbYEMJ10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 05:27:26 -0400
Date: Tue, 13 May 2008 11:27:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Dylan R. Semler" <dylan.semler@gmail.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] USB HID/HIDBP DRIVERS: Add iMON LCDs to HID blacklist
In-Reply-To: <4826192E.1030409@gmail.com>
Message-ID: <Pine.LNX.4.64.0805131126460.11363@jikos.suse.cz>
References: <4826192E.1030409@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 May 2008, Dylan R. Semler wrote:

> From: Dylan R Semler <dylan.semler@gmail.com>

> The new iMON LCDs from SoundGraph need to be blacklisted from HID in 
> order to be used by lirc. This patch adds vendor and device IDs for iMON 
> LCDs and adds them to the blacklist.

Hi Dylan,

the patch is whitespace damaged and line wrapped, could you please resend 
properly?

Thanks,

-- 
Jiri Kosina
