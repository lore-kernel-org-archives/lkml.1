Return-Path: <linux-kernel-owner+w=401wt.eu-S1755434AbYGVLEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434AbYGVLEg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752857AbYGVLE2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:04:28 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60084 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbYGVLE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:04:27 -0400
Date: Tue, 22 Jul 2008 11:46:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org
Subject: Re: Fix icom serial compile.
Message-ID: <20080722114649.575e22f6@lxorguk.ukuu.org.uk>
In-Reply-To: <20080722024100.GA23365@redhat.com>
References: <20080721211659.GA29106@redhat.com>
	<20080721221355.GD3472@redhat.com>
	<20080721230742.4649b94a@lxorguk.ukuu.org.uk>
	<20080722112538.03c06649.sfr@canb.auug.org.au>
	<20080722030519.7d0e5ee3@lxorguk.ukuu.org.uk>
	<20080722024100.GA23365@redhat.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Leaving the tree broken, and NACKing attempts to fix it don't seem to be
> particularly productive for anyone.

I NAKKed the fix because it would have broken the merge *AGAIN* which
would have messed up the merging for everything else all for the matter
of what four hours ?

> Please, less drama, more fixing.

Go see figure 1
