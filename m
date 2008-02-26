Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYBZMn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYBZMn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 07:43:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYBZMnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 07:43:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49290 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751330AbYBZMnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 07:43:20 -0500
Date: Tue, 26 Feb 2008 12:29:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: davids@webmaster.com
Cc: <Valdis.Kletnieks@vt.edu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       <linux-kernel@vger.kernel.org>, "Alan Cox" <alan@redhat.com>
Subject: Re: [PATCH] 2.6.25-rc2-mm1 - fix mcount GPL bogosity.
Message-ID: <20080226122932.5f83d6d4@core>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEKDKKAC.davids@webmaster.com>
References: <47C3078E.3000008@redhat.com>
	<MDEHLPKNGKAHNMBLJOLKGEKDKKAC.davids@webmaster.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't know who told you that or why, but it's obvious nonsense, as this
> issue shows. Exports should be marked GPL if and only if they cannot be used
> except in a derivative work. If it is possible to use them without taking
> sufficient protectable expression, they should not be marked GPL.
> 
> This was what everyone agreed to when GPL exports were created.

No it wasn't.

Alan
