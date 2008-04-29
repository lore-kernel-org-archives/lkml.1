Return-Path: <linux-kernel-owner+w=401wt.eu-S1758434AbYD2Jln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434AbYD2Jln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 05:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbYD2Jld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 05:41:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59089 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753722AbYD2Jlc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 05:41:32 -0400
Date: Tue, 29 Apr 2008 10:33:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Helge Hafting <helge.hafting@aitel.hist.no>
Cc: Willy Tarreau <w@1wt.eu>, Adrian Bunk <bunk@kernel.org>,
       "H. Peter Anvin" <hpa@kernel.org>, linux-kernel@vger.kernel.org,
       trivial@kernel.org
Subject: Re: [2.6 patch] UTF-8 fixes in comments
Message-ID: <20080429103355.00c61fc2@core>
In-Reply-To: <4816E4FD.5060605@aitel.hist.no>
References: <20080428154023.GU2813@cs181133002.pp.htv.fi>
	<20080428230524.GK8474@1wt.eu>
	<48167A07.4000305@kernel.org>
	<20080429050605.GA27875@1wt.eu>
	<20080429072911.GA28059@cs181133002.pp.htv.fi>
	<20080429081423.GD30507@1wt.eu>
	<4816E4FD.5060605@aitel.hist.no>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Outside the english-speaking world, userland _was_ completely

(American)

Formal UK English uses accented characters for some foreign imports (eg
café), ï for words like naïve, and if you are really pretentious you need
the æ symbol for words like mediæval although for modern writing this is
considered silly.

The bash problem btw should have been fixed (if it is bash causing it) as
of 2.05b and readline 4.3. If its being cause by the KDE terminal that
would suprise me but might be worth filing a bug.

Alan
