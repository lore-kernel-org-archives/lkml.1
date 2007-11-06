Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbXKFTk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbXKFTk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 14:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754413AbXKFTkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 14:40:22 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:59744 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754586AbXKFTkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 14:40:21 -0500
Date: Tue, 6 Nov 2007 20:39:31 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 0/4] Add ARCH_SUPPORTS_KPROBES (take 2)
Message-ID: <20071106203931.06063bab@dhcp-255-175.norway.atmel.com>
In-Reply-To: <20071031010345.301342580@polymtl.ca>
References: <20071031010345.301342580@polymtl.ca>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 21:03:45 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> take 2, using def_bool this time.

Currently, avr32 doesn't include kernel/Kconfig.instrumentation, but
defines KPROBES in arch/avr32/Kconfig.debug instead. I want to bring
avr32 in sync with everyone else, but that will obviously conflict with
this patchset.

Are these patches about to get merged or should I just send my stuff
upstream and ask you to rebase afterwards?

Håvard
