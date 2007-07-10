Return-Path: <linux-kernel-owner+w=401wt.eu-S1758896AbXGJIIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758896AbXGJIIj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 04:08:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbXGJII1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 04:08:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:53980 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754346AbXGJIIZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 04:08:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18Zi0wMArYZr2ovXHsUb1pNB3YwF03wkxrGEllTHo
	dv6iRlw4enhwkF
Subject: Re: [patch] CFS scheduler, -v19
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <20070706173319.GA2356@elte.hu>
References: <20070706173319.GA2356@elte.hu>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 10:08:22 +0200
Message-Id: <1184054902.12336.19.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

On Fri, 2007-07-06 at 19:33 +0200, Ingo Molnar wrote:
> i'm pleased to announce release -v19 of the CFS scheduler patchset.

I've taken mainline git tree (freshly integrated CFS!) out for a
multimedia spin.  I tested watching movies and listenign to music in the
presence of various sleep/burn loads, pure burn loads, and mixed loads.
All was peachy here.. I saw no frame drops or sound skips or other
artifacts under any load where the processor could possibly meet demand.

	-Mike

