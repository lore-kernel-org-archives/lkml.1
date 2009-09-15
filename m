Return-Path: <linux-kernel-owner+w=401wt.eu-S1752755AbZIOWgp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbZIOWgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 18:36:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbZIOWgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 18:36:41 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:47140 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751117AbZIOWgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 18:36:41 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Sep 2009 18:36:40 EDT
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, FUJITA Tomonori <tomof@acm.org>
In-Reply-To: <1253051488.8375.233.camel@pasglop>
References: <1252653473.8566.98.camel@pasglop>
	 <1252999835.8375.205.camel@pasglop>
	 <alpine.LFD.2.01.0909150943580.4950@localhost.localdomain>
	 <1253051488.8375.233.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Sep 2009 00:29:01 +0200
Message-Id: <1253053741.5669.1990.camel@thor>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 07:51 +1000, Benjamin Herrenschmidt wrote: 
> On Tue, 2009-09-15 at 09:53 -0700, Linus Torvalds wrote:
> > It got a conflict with the AGP merge, but I fixed it up in what _seemed_ 
> > to be the obvious manner. But somebody should check out the resulting
> > drivers/char/agp/uninorth-agp.c file.
> 
> Thanks. 
> 
> Michel, can you dbl check it ?

Looks good to me, thanks.


-- 
Earthling Michel Dänzer           |                http://www.vmware.com
Libre software enthusiast         |          Debian, X and DRI developer
