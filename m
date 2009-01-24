Return-Path: <linux-kernel-owner+w=401wt.eu-S1756062AbZAXV7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062AbZAXV7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 16:59:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757891AbZAXV7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 16:59:25 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:48034 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755748AbZAXV7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 16:59:24 -0500
Subject: Re: [trivial patch] fix missing space in printk
	drivers/serial/8250.c
From: Paul Bolle <pebolle@tiscali.nl>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-serial@vger.kernel.org, Linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <497B7C7F.80104@msgid.tls.msk.ru>
References: <497B7C7F.80104@msgid.tls.msk.ru>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 22:59:26 +0100
Message-Id: <1232834366.1569.13.camel@x41.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-24 at 23:39 +0300, Michael Tokarev wrote:
> Again, I don't know where to push this trivia thing.
> 8250 marked as Orphan in MAINTAINERS, so I'm sending
> to linux-serial@ AND to linux-kernel@

This was fixed by commit f1fb9bb8594cecf4e81e7a8ab8f6268e0bace40b
("trivial: Add a space (and a comma) to a printk in 8250 driver"), which
is the result of a patch that I sent to both trivial@kernel.org and
linux-kernel@vger.kernel.org a few weeks ago.

Regards,


Paul Bolle

