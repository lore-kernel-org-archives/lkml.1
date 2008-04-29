Return-Path: <linux-kernel-owner+w=401wt.eu-S1761222AbYD2JtE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761222AbYD2JtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:49:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYD2Jsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:48:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47235 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752004AbYD2Jsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:48:52 -0400
Date: Tue, 29 Apr 2008 10:41:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429104118.425dbeb1@core>
In-Reply-To: <20080429093458.GA1473@1wt.eu>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi>
	<20080428230524.GK8474@1wt.eu>
	<20080429100107.79ebf0cc@core>
	<20080429093458.GA1473@1wt.eu>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> "enabled" does not mean "working" Alan. I know one distro which I will
> not name in order not to offense you which shipped with it enabled by

No offence taken. In fact I seem to remember filing similar bugs at the
time about rpm/popt getting its help formatting wrong in some locales (eg
Welsh) for similar reasons - but that was some time ago.

All the mainstream tools handle utf-8 just fine, joe is quite happy
editing utf-8 these days (as are the legacy vim and emacs editing
tools ;)). There really are no good reasons left not to use UTF-8.

Alan
--
        > you are confusing me even more.  
        Of course.  "I'm from IBM.  I'm here to help."  ;-)
                                -- Alan Altmark
