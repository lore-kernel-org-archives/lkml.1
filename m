Return-Path: <linux-kernel-owner+w=401wt.eu-S1757796AbZABOYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757796AbZABOYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754930AbZABOYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:24:43 -0500
Received: from mx1.suse.de ([195.135.220.2]:42117 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbZABOYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:24:42 -0500
From: Andreas Schwab <schwab@suse.de>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>,
       Patrick McHardy <kaber@trash.net>,
       "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] linux/types.h: always export 64bit aligned defines
References: <1230885562-11456-1-git-send-email-vapier@gentoo.org>
X-Yow: Is it 1974?  What's for SUPPER?  Can I spend my COLLEGE FUND in
 one wild afternoon??
Date: Fri, 02 Jan 2009 15:24:39 +0100
In-Reply-To: <1230885562-11456-1-git-send-email-vapier@gentoo.org> (Mike
	Frysinger's message of "Fri, 2 Jan 2009 03:39:22 -0500")
Message-ID: <je4p0hhjko.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger <vapier@gentoo.org> writes:

> These these defines dont actually conflict with normal userspace / C
> library types, there's no reason to hide them behind the
> __KERNEL_STRICT_NAMES define.

aligned_u64 would pollute the name space, wouldn't it?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
