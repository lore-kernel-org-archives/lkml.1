Return-Path: <linux-kernel-owner+w=401wt.eu-S1032553AbXENL5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032553AbXENL5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 07:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762700AbXENLho
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 07:37:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35989 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762684AbXENLhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 07:37:42 -0400
Date: Mon, 14 May 2007 12:42:10 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bob Johnston <haloman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: undeprecate raw driver.
Message-ID: <20070514124210.71d94d58@the-village.bc.nu>
In-Reply-To: <loom.20070514T005958-424@post.gmane.org>
References: <E1HnHxK-0004CI-00@calista.eckenfels.net>
	<Pine.LNX.4.64.0705131347450.1144@localhost.localdomain>
	<464770A0.4070809@s5r6.in-berlin.de>
	<loom.20070514T005958-424@post.gmane.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 May 2007 23:01:51 +0000 (UTC)
Bob Johnston <haloman@gmail.com> wrote:

> Stefan Richter <stefanr <at> s5r6.in-berlin.de> writes:
> > So why don't we simply say:
> > 
> >   - "Users of feature A are urged to migrate to alternative B."
> >   - "Feature C will be removed in February 2038."
> > 
> > Everybody understands the meaning of /that/.
> 
> Why not just use the terms:
> * outdated - as a replacement for "deprecated".

Because they don't actually mean the same thing ?

> * toberemoved - as a replacement for "obsolete".

With spaces, I'd hope.
