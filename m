Return-Path: <linux-kernel-owner+w=401wt.eu-S1755425AbYB0Pww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbYB0Pww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 10:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYB0Pwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 10:52:44 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54472 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752885AbYB0Pwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 10:52:44 -0500
Date: Wed, 27 Feb 2008 16:50:30 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Ben Nizette <bn@niasdigital.com>
Subject: Re: 2.6.25-rc3: Reported regressions from 2.6.24
Message-ID: <20080227165030.56032c84@hskinnemoen.norway.atmel.com>
In-Reply-To: <200802250241.40832.rjw@sisk.pl>
References: <200802250241.40832.rjw@sisk.pl>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008 02:41:40 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9976
> Subject		: BUG: 2.6.25-rc1: iptables postrouting setup causes oops
> Submitter	: Ben Nizette <bn@niasdigital.com>
> Date		: 2008-02-12 12:46
> References	: http://lkml.org/lkml/2008/2/12/148
> Handled-By	: Haavard Skinnemoen <hskinnemoen@atmel.com>
> Patch		: http://lkml.org/lkml/2008/2/13/177

Actually, that patch doesn't fix the real problem -- it only makes the
Oops output a bit more sensible.

Ben, did you manage to reproduce it with that patch applied?

Haavard
