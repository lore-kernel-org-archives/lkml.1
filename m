Return-Path: <linux-kernel-owner+w=401wt.eu-S1757347AbXIERR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347AbXIERR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 13:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbXIERRw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 13:17:52 -0400
Received: from mx1.suse.de ([195.135.220.2]:46572 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbXIERRv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 13:17:51 -0400
From: Andreas Schwab <schwab@suse.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: modinfo <modulename> question
References: <Pine.LNX.4.64.0709051232440.22864@p34.internal.lan>
X-Yow: Then, it's off to RED CHINA!!
Date: Wed, 05 Sep 2007 19:17:50 +0200
In-Reply-To: <Pine.LNX.4.64.0709051232440.22864@p34.internal.lan> (Justin
	Piszcz's message of "Wed\, 5 Sep 2007 12\:34\:13 -0400 \(EDT\)")
Message-ID: <jesl5tuj41.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Piszcz <jpiszcz@lucidpixels.com> writes:

> Is there anyway to get/see what parameters were passed to a kernel module?

/sys/module/<module>/parameters

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
