Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYJIRDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYJIRDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbYJIRDF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:03:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:54520 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753856AbYJIRDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:03:04 -0400
From: Andreas Schwab <schwab@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: torvalds@linux-foundation.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: splice vs O_APPEND
References: <E1Knx26-0003ds-Ch@pomaz-ex.szeredi.hu>
	<alpine.LFD.2.00.0810090830170.3210@nehalem.linux-foundation.org>
	<E1Knxzm-0003y2-Jy@pomaz-ex.szeredi.hu> <jeskr5g29i.fsf@sykes.suse.de>
	<E1KnybM-0004AD-3V@pomaz-ex.szeredi.hu>
X-Yow: Will this never-ending series of PLEASURABLE EVENTS never cease?
Date: Thu, 09 Oct 2008 19:03:00 +0200
In-Reply-To: <E1KnybM-0004AD-3V@pomaz-ex.szeredi.hu> (Miklos Szeredi's message
	of "Thu, 09 Oct 2008 18:43:00 +0200")
Message-ID: <jeiqs1g0qj.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> I checked and it does.  Nobody seems to care though, not even the
> POSIX conformance checkers :)

According to
<http://bugs.opensolaris.org/bugdatabase/view_bug.do?bug_id=6655660>
they do now.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
