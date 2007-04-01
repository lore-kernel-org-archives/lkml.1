Return-Path: <linux-kernel-owner+w=401wt.eu-S965095AbXDAWEx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965095AbXDAWEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 18:04:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965263AbXDAWEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 18:04:53 -0400
Received: from cantor.suse.de ([195.135.220.2]:39734 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965095AbXDAWEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 18:04:52 -0400
To: Kyle Moffett <mrmacman_g4@mac.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH]
References: <Pine.LNX.4.61.0704011900470.8018@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0704012006060.12316@yvahk01.tjqt.qr>
	<B118D361-9F40-456F-96B7-E61B16B98432@mac.com>
	<Pine.LNX.4.61.0704012040220.15102@yvahk01.tjqt.qr>
	<2E204ACD-E697-42C6-8F01-22C1B7B4A85B@mac.com>
	<Pine.LNX.4.61.0704012058060.16977@yvahk01.tjqt.qr>
	<D260104B-C775-474E-B246-6298CD175205@mac.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 02 Apr 2007 01:03:16 +0200
In-Reply-To: <D260104B-C775-474E-B246-6298CD175205@mac.com>
Message-ID: <p733b3jr93f.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kyle Moffett <mrmacman_g4@mac.com> writes:

> Add a CONFIG_I_KNOW_WHAT_THE_HELL_I_AM_DOING variable with a really
> strong
> warning attached to it (and a shorter CONFIG_EXPERT variable for use in
> Kconfig files where it's a PITA to type out the full name)

When you know what you're doing you can just patch then Kconfig files.
IMHO that's better than this.

-Andi
