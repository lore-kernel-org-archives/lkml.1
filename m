Return-Path: <linux-kernel-owner+w=401wt.eu-S1758080AbYJVWPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758080AbYJVWPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 18:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752075AbYJVWPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 18:15:23 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42303 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752466AbYJVWPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 18:15:22 -0400
Date: Wed, 22 Oct 2008 23:15:00 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akataria@vmware.com
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Skip tsc synchronization checks if CONSTANT_TSC bit is
 set.
Message-ID: <20081022231500.4172bba3@lxorguk.ukuu.org.uk>
In-Reply-To: <1224712846.13953.37.camel@alok-dev1>
References: <1224552902.2640.88.camel@alok-dev1>
	<874p36fflp.fsf@basil.nowhere.org>
	<1224607284.6161.22.camel@alok-dev1>
	<20081021174008.GH12825@one.firstfloor.org>
	<1224612294.6161.43.camel@alok-dev1>
	<20081021181536.GI12825@one.firstfloor.org>
	<1224616236.6161.60.camel@alok-dev1>
	<20081021192746.GJ12825@one.firstfloor.org>
	<1224703427.13953.8.camel@alok-dev1>
	<20081022195845.GP12825@one.firstfloor.org>
	<1224712846.13953.37.camel@alok-dev1>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2008 15:00:46 -0700
Alok Kataria <akataria@vmware.com> wrote:

> [dropped LKML of the cc list]

Sorry this discussion belongs on the LKML list. Please take it back to
the list.
