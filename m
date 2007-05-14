Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbXENTP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbXENTP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754761AbXENTPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:15:22 -0400
Received: from www.osadl.org ([213.239.205.134]:39032 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753043AbXENTPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:15:21 -0400
Subject: Re: [PATCH][RFC] Remove final vestiges of interrupt-related "SA_"
	flags.
From: Thomas Gleixner <tglx@linutronix.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4648B324.2030801@goop.org>
References: <Pine.LNX.4.64.0705141433490.14658@localhost.localdomain>
	 <1179169434.7074.9.camel@chaos>  <4648B324.2030801@goop.org>
Content-Type: text/plain
Date: Mon, 14 May 2007 21:18:44 +0200
Message-Id: <1179170324.7074.16.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-14 at 12:06 -0700, Jeremy Fitzhardinge wrote:
> > NAK, the removal date is September 2007 so out of tree folks have some
> > time to fix their crap.
> 
> This might be a good example of targeting a specific kernel version
> rather than a date, since anyone who can't fix this immediately with a
> simple search'n'replace is probably trying to support multiple kernels,
> and knowing that "2.6.24" (or whatever) is the cut-off version is more
> useful than "whatever kernel is current in Sept 2007".

Makes sense. OTOH folks can do the math on their own :)

	tglx


