Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbXH0L6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbXH0L6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 07:58:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751039AbXH0L6r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 07:58:47 -0400
Received: from mx1.suse.de ([195.135.220.2]:59058 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbXH0L6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 07:58:46 -0400
From: Andreas Schwab <schwab@suse.de>
To: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: "Esteban Fernandez" <estfern@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Pausing kernel boot messages
References: <179e6e720708270421r5f07f9dfp434077f6a106d2d7@mail.gmail.com>
	<200708271353.22665.hjk@linutronix.de>
X-Yow: Here we are in America...  when do we collect unemployment?
Date: Mon, 27 Aug 2007 13:58:45 +0200
In-Reply-To: <200708271353.22665.hjk@linutronix.de> (=?iso-8859-1?Q?=22Han?=
 =?iso-8859-1?Q?s-J=FCrgen?= Koch"'s
	message of "Mon\, 27 Aug 2007 13\:53\:22 +0200")
Message-ID: <jesl6542a2.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Jürgen Koch <hjk@linutronix.de> writes:

> Am Montag 27 August 2007 13:21 schrieb Esteban Fernandez:
>> How do you pause the kernel boot messages ?
>> 
>> ^S, Pause and Scroll lock do nothing and you can't Shift-Page-Up  after a
>> kernel panic.
>
> These are functions of a shell (like bash),

Definitely not.  The shell is not a console driver, it only uses it.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
