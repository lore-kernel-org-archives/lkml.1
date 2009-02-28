Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZB1Rao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZB1Rao (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 12:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbZB1Rag
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 12:30:36 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33924 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752758AbZB1Raf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 12:30:35 -0500
Date: Sat, 28 Feb 2009 09:30:28 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Takashi Iwai <tiwai@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] ALSA fixes for 2.6.29-rc6
In-Reply-To: <s5hhc2i9w6p.wl%tiwai@suse.de>
Message-ID: <alpine.LFD.2.00.0902280929480.3111@localhost.localdomain>
References: <s5hhc2i9w6p.wl%tiwai@suse.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Did this address

	http://bugzilla.kernel.org/show_bug.cgi?id=12735

or is that still pending? I realize that there is a hack around it, but 
that hack isn't actually appropriate for a distro kernel, so..

		Linus
