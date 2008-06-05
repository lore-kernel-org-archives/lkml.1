Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbYFERGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbYFERGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbYFERGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:06:47 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:58067 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbYFERGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:06:46 -0400
Date: Thu, 5 Jun 2008 19:06:57 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Geoffrey Wossum <geoffrey@pager.net>, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org
Subject: Re: AT32 ASoC Driver Patches on alsa-devel
Message-ID: <20080605190657.754df524@hskinnemo-gx745.norway.atmel.com>
In-Reply-To: <s5hod6f3jrq.wl%tiwai@suse.de>
References: <200806050851.47319.geoffrey@pager.net>
	<20080605162206.0a34a54e@hskinnemo-gx745.norway.atmel.com>
	<200806051000.56969.geoffrey@pager.net>
	<20080605182409.6285ee4b@hskinnemo-gx745.norway.atmel.com>
	<s5hod6f3jrq.wl%tiwai@suse.de>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 05 Jun 2008 17:06:21.0933 (UTC) FILETIME=[7A9901D0:01C8C72E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:
> Of course, important.  And it's actually done in a different way...
[...]
> Of course, important.  And it's actually done in a different way...

But why?

> Ideally, more fusion would be possible, but practically it's not
> always worth.  I don't think you want to merge codes between ext3 and
> reiserfs although both have similar "design goals" :)

Still, both plug into the same VFS layer...

Reiser4 tried to invent its own plugin system. IIRC that didn't fly
particularly well.

Haavard
