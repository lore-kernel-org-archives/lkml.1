Return-Path: <linux-kernel-owner+w=401wt.eu-S1757770AbYJMNTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770AbYJMNTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 09:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758251AbYJMNSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 09:18:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35760 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758182AbYJMNSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 09:18:52 -0400
Date: Mon, 13 Oct 2008 10:18:26 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: What's in linux1394-2.6.git?
Message-ID: <20081013101826.69f8c67e@pedra.chehab.org>
In-Reply-To: <tkrat.b23c4b2f8887d5b5@s5r6.in-berlin.de>
References: <tkrat.b23c4b2f8887d5b5@s5r6.in-berlin.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Oct 2008 20:30:35 +0200 (CEST)
Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> I suppose I will ask Mauro instead of Linus to pull the driver, although
> the patch queue does not touch the DVB subsystem except for adding the
> driver to the Makefile and Kconfig.

Seems fine for me. As we've added several new drivers for 2.6.28, this is
also safer to avoid (trivial) conflicts.

Cheers,
Mauro
