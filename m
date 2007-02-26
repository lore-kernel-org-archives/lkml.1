Return-Path: <linux-kernel-owner+w=401wt.eu-S1161228AbXBZVyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161228AbXBZVyW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 16:54:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161226AbXBZVyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 16:54:22 -0500
Received: from mx1.suse.de ([195.135.220.2]:53367 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161227AbXBZVyQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 16:54:16 -0500
From: Andreas Schwab <schwab@suse.de>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: Nvidiafb broken in 2.6.21-rc1
References: <jezm737pxc.fsf@sykes.suse.de>
	<1172484121.5824.1.camel@localhost.localdomain>
X-Yow: I have accepted Provolone into my life!
Date: Mon, 26 Feb 2007 22:54:06 +0100
In-Reply-To: <1172484121.5824.1.camel@localhost.localdomain> (Richard Purdie's
	message of "Mon, 26 Feb 2007 10:02:01 +0000")
Message-ID: <jer6sc60w1.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Purdie <rpurdie@rpsys.net> writes:

> Thanks, I think I know what the problem is. Could you try this change
> please:

Thanks, that fixes the problem.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
