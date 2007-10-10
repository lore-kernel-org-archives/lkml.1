Return-Path: <linux-kernel-owner+w=401wt.eu-S1757419AbXJJX1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419AbXJJX1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2007 19:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756839AbXJJX1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Oct 2007 19:27:10 -0400
Received: from khc.piap.pl ([195.187.100.11]:58560 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756831AbXJJX1J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2007 19:27:09 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: =?iso-8859-1?Q?Ren=E9?= Rebe <rene@exactcode.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.23
References: <alpine.LFD.0.999.0710091346490.5039@woody.linux-foundation.org>
	<200710100944.16378.rene@exactcode.de> <20071010191413.GB3589@elte.hu>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 11 Oct 2007 01:27:06 +0200
In-Reply-To: <20071010191413.GB3589@elte.hu> (Ingo Molnar's message of "Wed, 10 Oct 2007 21:14:13 +0200")
Message-ID: <m3sl4i8sad.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> - an uncommon embedded config combinatio: if CONFIG_EMBEDDED=y and
>   CONFIG_BLOCK is unset. (a normally useless combination)

Uncommon but far from useless - may be pure initramfs-based.
-- 
Krzysztof Halasa
