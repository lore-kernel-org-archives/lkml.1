Return-Path: <linux-kernel-owner+w=401wt.eu-S1761505AbYDYOSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761505AbYDYOSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 10:18:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756817AbYDYOS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 10:18:28 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:59633 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756626AbYDYOS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 10:18:26 -0400
Date: Fri, 25 Apr 2008 16:18:18 +0200
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for April 24
Message-ID: <20080425141818.GA8043@Chamillionaire.breakpoint.cc>
References: <20080424173626.bcd088e7.sfr@canb.auug.org.au> <Pine.LNX.4.64.0804240942300.10239@vixen.sonytel.be> <20080424193023.862cacd7.sfr@canb.auug.org.au> <Pine.LNX.4.64.0804241311330.7107@anakin> <20080425172039.326f4bfd.sfr@canb.auug.org.au> <1209130375.30293.1.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1209130375.30293.1.camel@localhost>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michael Ellerman | 2008-04-25 23:32:55 [+1000]:

>We take a snapshot with wget, that /should/ be consistent, ie. no
>dangling links. But then that gets rsync'ed, and it's possible if you're
>browsing while the rsync is going you'll get a link to nowhere.
--delete-after --delay-updates --partial-dir

>cheers
>
>-- 
>Michael Ellerman

Sebastian
