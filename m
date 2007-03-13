Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbXCMTTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbXCMTTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 15:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933534AbXCMTTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 15:19:30 -0400
Received: from mail.suse.de ([195.135.220.2]:34147 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933054AbXCMTT3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 15:19:29 -0400
From: Andreas Schwab <schwab@suse.de>
To: Johannes Bauer <JohannesBauer@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: x86_64 system lockup from userspace using setitimer()
References: <45F6F3A6.9060405@gmx.de>
X-Yow: I want you to organize my PASTRY trays...  my TEA-TINS are gleaming in
 formation like a ROW of DRUM MAJORETTES --
 please don't be FURIOUS with me --
Date: Tue, 13 Mar 2007 20:19:27 +0100
In-Reply-To: <45F6F3A6.9060405@gmx.de> (Johannes Bauer's message of "Tue, 13
	Mar 2007 19:55:34 +0100")
Message-ID: <jey7m1hry8.fsf@sykes.suse.de>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/22.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Bauer <JohannesBauer@gmx.de> writes:

> Dear Community,
>
> I think I've encountered a bug with the Linux kernel which results in a
> complete system lockup and which can be started without root
> priviliges. It's reproducible with 2.6.20.1 and 2.6.20.2 and only x64_64
> seems affected.

I can also reproduce it on ia64 with 2.6.20.  2.6.16.42 is ok.

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
