Return-Path: <linux-kernel-owner+w=401wt.eu-S1751038AbYKYJWN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751038AbYKYJWN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 04:22:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYKYJV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 04:21:59 -0500
Received: from eazy.amigager.de ([213.239.192.238]:34952 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbYKYJV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 04:21:59 -0500
Date: Tue, 25 Nov 2008 10:21:57 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc regression: digital audio inactive after resume from
	suspend
Message-ID: <20081125092157.GA5532@dose.home.local>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	linux-kernel@vger.kernel.org
References: <20081124212225.GA5872@dose.home.local> <s5hiqqcra95.wl%tiwai@suse.de> <20081125070312.GA6533@dose.home.local> <s5hy6z8tgx3.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hy6z8tgx3.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 08:15:36 +0100, Takashi Iwai wrote:

[...]

> Could you try the patch below?

This patch fixed it, thanks.

Regards,
Tino
