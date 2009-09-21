Return-Path: <linux-kernel-owner+w=401wt.eu-S1754856AbZIUHrJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbZIUHrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:47:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752673AbZIUHrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:47:07 -0400
Received: from mail.gmx.net ([213.165.64.20]:45721 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752620AbZIUHrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:47:06 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/zHPBli8rzMG3j20y7eYReTFWGqegPZcCWCbV4DT
	JsnsP+kR3sJ5MO
Subject: Re: Poor desktop responsiveness with background I/O-operations
From: Mike Galbraith <efault@gmx.de>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Jiri Kosina <jkosina@suse.cz>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1253518906.25640.41.camel@marge.simson.net>
References: <4AB59CBB.8090907@datenparkplatz.de>
	 <alpine.LRH.2.00.0909202221010.25928@twin.jikos.cz>
	 <20090920220405.GA395@duck.suse.cz>
	 <1253517908.25640.37.camel@marge.simson.net>
	 <20090921093328.75ae5519@infradead.org>
	 <1253518906.25640.41.camel@marge.simson.net>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 09:47:07 +0200
Message-Id: <1253519227.25640.42.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 09:41 +0200, Mike Galbraith wrote:
> On Mon, 2009-09-21 at 09:33 +0200, Arjan van de Ven wrote:
> > On Mon, 21 Sep 2009 09:25:08 +0200
> > Mike Galbraith <efault@gmx.de> wrote:
> > > I still occasionally see some largish numbers though, and suspect that
> > > depends on how much cache was evicted.
> > 
> > if you run latencytop it'll at least tell you what kind of operating
> > was going on that hit the delay...
> 
> One of the really bad ones for evolution is below.  It was so bad that I
> had _plenty_ of time to get to a GUI free shell, and poke SysRq-W before
> killing the darn dd.

P.S.  evolution is always journal journal and more journal.

