Return-Path: <linux-kernel-owner+w=401wt.eu-S1755024AbZEWQpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024AbZEWQpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 12:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbZEWQpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 12:45:44 -0400
Received: from bu3sch.de ([62.75.166.246]:55660 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752993AbZEWQpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 12:45:44 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Michael Riepe <michael.riepe@googlemail.com>
Subject: Re: [PATCH 2.6.30-rc4] r8169: avoid losing MSI interrupts
Date: Sat, 23 May 2009 18:45:00 +0200
User-Agent: KMail/1.9.9
Cc: David Dillow <dave@thedillows.org>, Francois Romieu <romieu@fr.zoreil.com>,
       Rui Santos <rsantos@grupopie.com>,
       Michael =?iso-8859-1?q?B=FCker?= <m.bueker@berlin.de>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
References: <200903041828.49972.m.bueker@berlin.de> <1243090308.4217.6.camel@obelisk.thedillows.org> <4A182066.9030201@googlemail.com>
In-Reply-To: <4A182066.9030201@googlemail.com>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905231845.00585.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 23 May 2009 18:12:22 Michael Riepe wrote:

> CPU 0+2:  0.0-60.0 sec  4.65 GBytes    665 Mbits/sec
> CPU 1+3:  0.0-60.0 sec  6.43 GBytes    920 Mbits/sec
> 
> That's quite a difference, isn't it?
> 
> Now I wonder what CPU 0 is doing...

Is CPU0 the only one servicing interrupts?

-- 
Greetings, Michael.
