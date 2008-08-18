Return-Path: <linux-kernel-owner+w=401wt.eu-S1753111AbYHRJOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbYHRJOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 05:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751455AbYHRJOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 05:14:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45172 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752604AbYHRJOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 05:14:03 -0400
Date: Mon, 18 Aug 2008 09:56:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Grant Coady <gcoady.lk@gmail.com>
Cc: grant_lkml@dodo.com.au, Mikael Pettersson <mikpe@it.uu.se>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ATA Kconfig cleanup: sort the driver list and modify
 some text
Message-ID: <20080818095640.5f9b52f2@lxorguk.ukuu.org.uk>
In-Reply-To: <5rkha4l846d0benss3hip3nvr0cmnfi1k4@4ax.com>
References: <qjoca411hv4hm25keq70ul5pnbi7747d13@4ax.com>
	<18598.42334.73411.476062@harpo.it.uu.se>
	<20080816113224.5562a9a6@lxorguk.ukuu.org.uk>
	<5rkha4l846d0benss3hip3nvr0cmnfi1k4@4ax.com>
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

On Mon, 18 Aug 2008 11:47:46 +1000
Grant Coady <grant_lkml@dodo.com.au> wrote:

> On Sat, 16 Aug 2008 11:32:24 +0100, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> 
> >> I suspect sata_via will want this too.
> >
> >Lust about any PATA chip may be on boards with SATA bridges so the divide
> >doesn't really work.
> 
> Okay, following patch is just the driver sort and text changes.  I have a 
> 4/3 fixup patch for the last lot but suspect it's a lost cause.

Sorting the list I think is definitely worthwhile so I am in favour of
this set.
