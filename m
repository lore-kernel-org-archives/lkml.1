Return-Path: <linux-kernel-owner+w=401wt.eu-S1754158AbYIHRCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158AbYIHRCZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 13:02:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYIHRCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 13:02:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34081 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751458AbYIHRCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 13:02:13 -0400
Date: Mon, 8 Sep 2008 18:01:25 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Hugh Dickens <hugh@veritas.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH 0 of 3] Low memory corruption detection and workaround
Message-ID: <20080908180125.7e7ef369@lxorguk.ukuu.org.uk>
In-Reply-To: <48C5570B.7050109@goop.org>
References: <patchbomb.1220777491@localhost>
	<48C3F237.1020503@tuffmail.co.uk>
	<200809082123.04780.nickpiggin@yahoo.com.au>
	<48C5570B.7050109@goop.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Sep 2008 09:47:07 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Nick Piggin wrote:
> > Why not high memory as well? We put page tables there too...
> >   
> 
> Well, the specific problem is that the BIOS appears to corrupt low
> memory.  It might corrupt other memory anywhere, but that would be
> pretty pathologically evil.  The assumption is that it gets away with it
> because its memory that Windows doesn't otherwise use or something.

Or that its hitting stuff that doesn't kill the OS...

What has the vendor had to say and if they are not being helpful has
anyone considered delivered them a report of the corruption and trace info
by say registered post with a suggestion that they might now be knowingly
exposing customers to unneccessary risk through their inaction ...

Alan
