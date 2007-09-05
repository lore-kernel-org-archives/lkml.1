Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbXIEQS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbXIEQS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 12:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXIEQST
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 12:18:19 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359AbXIEQSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 12:18:18 -0400
Date: Wed, 5 Sep 2007 09:16:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: roger@computer-surgery.co.uk, linux-kernel@vger.kernel.org, perex@suse.cz
Subject: Re: hda_intel : Patch + Regression in 2.6.18 -> 2.6.22
Message-Id: <20070905091633.87cfaa81.akpm@linux-foundation.org>
In-Reply-To: <s5hlkbl6qsn.wl%tiwai@suse.de>
References: <20070822222902.GA28563@computer-surgery.co.uk>
	<20070905083844.6637da1e.akpm@linux-foundation.org>
	<s5hlkbl6qsn.wl%tiwai@suse.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, 05 Sep 2007 18:05:44 +0200 Takashi Iwai <tiwai@suse.de> wrote:
> Roger, could you try git-alsa patch in the latest mm together with
> model=acer-aspiore option?  If it works, I can easily add your device
> ID to the table.

http://userweb.kernel.org/~akpm/git-alsa.patch is a copy of the alsa git
tree as of two minutes ago.  That applies against current Linus mainline,
but should apply OK on 2.6.23-rc5 as well.  Please test that, thanks.

Takashi, perhaps that is 2.6.23 material?

