Return-Path: <linux-kernel-owner+w=401wt.eu-S1755529AbZALPwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbZALPwY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 10:52:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbZALPwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 10:52:15 -0500
Received: from tservice.net.ru ([195.178.208.66]:39567 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751979AbZALPwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 10:52:14 -0500
Date: Mon, 12 Jan 2009 18:52:11 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux killed Kenny, bastard!
Message-ID: <20090112155211.GA21161@ioremap.net>
References: <20090112153304.GA19995@ioremap.net> <20090112154456.GA27269@redhat.com> <20090112154827.GB20743@ioremap.net> <20090112155108.2646b3ae@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112155108.2646b3ae@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2009 at 03:51:08PM +0000, Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > Well, Kenny has to die, but if we still decide to change the world, here
> > is the fist step.
> 
> NAK this entire thing - we have an existing interface that does the job
> far better.

Modulo the fact that it does not work for the quickly created processes
which do not have their oom scores adjusted before the oom.

-- 
	Evgeniy Polyakov
