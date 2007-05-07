Return-Path: <linux-kernel-owner+w=401wt.eu-S964810AbXEGPZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbXEGPZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 11:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934405AbXEGPZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 11:25:42 -0400
Received: from www.osadl.org ([213.239.205.134]:48961 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934407AbXEGPZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 11:25:41 -0400
Subject: Re: [PATCH] x86-64 highres/dyntick support
From: Thomas Gleixner <tglx@linutronix.de>
Reply-To: tglx@linutronix.de
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <loom.20070507T111514-504@post.gmane.org>
References: <1178485128.31213.98.camel@localhost.localdomain>
	 <loom.20070507T111514-504@post.gmane.org>
Content-Type: text/plain
Date: Mon, 07 May 2007 17:28:24 +0200
Message-Id: <1178551705.3042.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-07 at 09:16 +0000, Nicolas Mailhot wrote:
> Thomas Gleixner <tglx <at> linutronix.de> writes:
> 
> > 
> > I'm pleased to announce the first cut of the final x86_64
> > highres/dyntick support, which I did based on Chris Wright's patch set,
> > which is again based on Arjan van de Ven's initial work:
> 
> Do you have a 2.6.21-mm1 patchset?

Not yet, but it should be halfways easy to do one. Stay tuned.

	tglx


