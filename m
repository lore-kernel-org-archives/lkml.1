Return-Path: <linux-kernel-owner+w=401wt.eu-S1751748AbYAOPqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748AbYAOPqQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 10:46:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751028AbYAOPp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 10:45:59 -0500
Received: from javad.com ([216.122.176.236]:2322 "EHLO javad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYAOPp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 10:45:58 -0500
X-Greylist: delayed 894 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jan 2008 10:45:58 EST
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/5] Char: mxser, remove special baudrate processing
References: <1199023138-27917-1-git-send-email-jirislaby@gmail.com>
From: Sergei Organov <osv@javad.com>
Date: Tue, 15 Jan 2008 18:30:50 +0300
In-Reply-To: <1199023138-27917-1-git-send-email-jirislaby@gmail.com> (Jiri Slaby's message of "Sun\, 30 Dec 2007 14\:58\:54 +0100")
Message-ID: <87tzlfnm1h.fsf@osv.gnss.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jirislaby@gmail.com> writes:
> If you, Sergei, can test it, it would be great. [Note, that this is actually
> a patch for mxser_new after renaming.]

Where is the reference git tree for this patch? Or, in other words,
which tree do I use if I want to test this patch (I'm afraid the latest
I've ever built, 2.6.19.1, is too old for this material)?

I've also checked

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git

and it seems it doesn't have commit that renames mxser_new to mxser.

-- 
Sergei.

