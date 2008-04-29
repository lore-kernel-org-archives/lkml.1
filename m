Return-Path: <linux-kernel-owner+w=401wt.eu-S1758099AbYD2WYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbYD2WYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 18:24:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753634AbYD2WYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 18:24:23 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60855 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753156AbYD2WYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 18:24:22 -0400
Date: Tue, 29 Apr 2008 23:15:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Helge Hafting <helge.hafting@aitel.hist.no>, Adrian Bunk <bunk@kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429231554.69973c45@core>
In-Reply-To: <20080429221230.GA17360@1wt.eu>
References: <20080428230524.GK8474@1wt.eu>
	<48167A07.4000305@kernel.org>
	<20080429050605.GA27875@1wt.eu>
	<20080429072911.GA28059@cs181133002.pp.htv.fi>
	<20080429081423.GD30507@1wt.eu>
	<4816E4FD.5060605@aitel.hist.no>
	<20080429100934.GB1473@1wt.eu>
	<20080429111014.5a065b88@core>
	<20080429103335.GD1473@1wt.eu>
	<20080429113410.0971d071@core>
	<20080429221230.GA17360@1wt.eu>
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

> OK I could reproduce the case without ever involving either a shell or
> readline or anything. Using "cat" as the init program exhibited the
> anomaly, though it was not much easy to analyze. Then I switched to
> "init=od -An -tx1 -".

Did you put the console into utf-8 mode before the cat ?
