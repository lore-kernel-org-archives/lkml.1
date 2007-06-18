Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbXFRFMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbXFRFMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 01:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXFRFMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 01:12:16 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57972 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647AbXFRFMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 01:12:15 -0400
Date: Sun, 17 Jun 2007 22:11:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [patch] make hdrscheck.sh force __asm__ in exported headers
Message-Id: <20070617221140.f1564f92.akpm@linux-foundation.org>
In-Reply-To: <200706171854.24763.vapier@gentoo.org>
References: <200706171854.24763.vapier@gentoo.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007 18:54:24 -0400 Mike Frysinger <vapier@gentoo.org> wrote:

> This updates scripts/hdrschecks.sh by grepping for asm() constructs and
> rejecting them in favor of __asm__() in exported headers.

And does the kernel pass these checks?  Which architectures have been tested?
