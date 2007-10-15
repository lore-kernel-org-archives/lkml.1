Return-Path: <linux-kernel-owner+w=401wt.eu-S933813AbXJOUpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813AbXJOUpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 16:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764013AbXJOUpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 16:45:20 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762552AbXJOUpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 16:45:18 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64N.0710151624140.16262@blysk.ds.pg.gda.pl>
References: <Pine.LNX.4.64N.0710151624140.16262@blysk.ds.pg.gda.pl> <Pine.LNX.4.64N.0710121633480.21684@blysk.ds.pg.gda.pl> <21428.1192267071@redhat.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] frv: Remove duplicate output of .exit.data
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Mon, 15 Oct 2007 21:43:04 +0100
Message-ID: <21474.1192480984@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maciej W. Rozycki <macro@linux-mips.org> wrote:

>  Fair enough -- a quick test shows you are right.  Wouldn't it deserve a 
> comment, though?  I know hardly anybody dares looking into these scripts, 
> ;-) but those who do, may not be sure this setup is intentional.

Probably.

David
