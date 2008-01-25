Return-Path: <linux-kernel-owner+w=401wt.eu-S1757570AbYAYNrk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757570AbYAYNrk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 08:47:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755118AbYAYNrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 08:47:32 -0500
Received: from ns2.suse.de ([195.135.220.15]:59513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754831AbYAYNrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 08:47:31 -0500
From: Andreas Schwab <schwab@suse.de>
To: "Jack Harvard" <jack.harvard@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q: linux failed to execute /init?
References: <a72f6a3c0801250538m57a91629o59242fad9e7d0265@mail.gmail.com>
	<a72f6a3c0801250540l73aacf9bvcebf50c23da3943e@mail.gmail.com>
X-Yow: I know th'MAMBO!!  I have a TWO-TONE CHEMISTRY SET!!
Date: Fri, 25 Jan 2008 14:47:30 +0100
In-Reply-To: <a72f6a3c0801250540l73aacf9bvcebf50c23da3943e@mail.gmail.com>
	(Jack Harvard's message of "Fri\, 25 Jan 2008 13\:40\:41 +0000")
Message-ID: <je3asmdnkd.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jack Harvard" <jack.harvard@googlemail.com> writes:

> Hi,
>
> I'm trying to boot Linux, but the /init process failed. Here is the
> info:
>
> =FF<6>/init exit code: -14
> /init exit code: -14
> <4>Failed to execute /init
> Failed to execute /init
>  <6>/sbin/init exit code: -14
>
> Just wondering what do those different exit codes mean?

#define EFAULT          14      /* Bad address */

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
