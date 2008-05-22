Return-Path: <linux-kernel-owner+w=401wt.eu-S934526AbYEVIK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526AbYEVIK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761166AbYEVIKB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:10:01 -0400
Received: from mx1.suse.de ([195.135.220.2]:60809 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760229AbYEVIJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:09:59 -0400
From: Andreas Schwab <schwab@suse.de>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, viro@ZenIV.linux.org.uk, paulus@samba.org,
       tiwai@suse.de, linux-kernel@vger.kernel.org
Subject: Re: Moving include/asm-*
References: <alpine.LFD.1.10.0805211635040.3081@woody.linux-foundation.org>
	<20080522005657.GU28946@ZenIV.linux.org.uk>
	<alpine.LFD.1.10.0805211818550.3081@woody.linux-foundation.org>
	<20080521.182335.28689253.davem@davemloft.net>
X-Yow: My pants just went to high school in the Carlsbad Caverns!!!
Date: Thu, 22 May 2008 10:09:51 +0200
In-Reply-To: <20080521.182335.28689253.davem@davemloft.net> (David Miller's
	message of "Wed, 21 May 2008 18:23:35 -0700 (PDT)")
Message-ID: <je1w3uu5dc.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

> If you want to figure out where something is implemented for a given
> target, you have to walk through the tree like a monkey in some
> prioritized list of directories to find the source file or header file
> that glibc ends up using.

The dependencies file contains the exact list of used files.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
