Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbYCUWZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbYCUWZm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 18:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbYCUWZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:25:34 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60256 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754192AbYCUWZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:25:33 -0400
Date: Fri, 21 Mar 2008 22:09:41 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, arjan@infradead.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [1/2] vmalloc: Show vmalloced areas via /proc/vmallocinfo
Message-ID: <20080321220941.6b441801@core>
In-Reply-To: <20080321151935.6a330536.akpm@linux-foundation.org>
References: <20080318222701.788442216@sgi.com>
	<20080318222827.291587297@sgi.com>
	<20080319210436.191bb8fe@laptopd505.fenrus.org>
	<Pine.LNX.4.64.0803201141250.10592@schroedinger.engr.sgi.com>
	<20080321151935.6a330536.akpm@linux-foundation.org>
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

> That makes the feature somewhat less useful.  Let's think this through more
> carefully - it is, after all, an unrevokable, unalterable addition to the
> kernel ABI.

Which means it does not belong in /proc.

Alan
