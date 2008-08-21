Return-Path: <linux-kernel-owner+w=401wt.eu-S1758700AbYHUKvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758700AbYHUKvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 06:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754434AbYHUKvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 06:51:39 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:50066 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615AbYHUKvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 06:51:39 -0400
Subject: Re: BUG in free_block (tainted)
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Simon Arlott <simon@fire.lp0.eu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
In-Reply-To: <1219315723.8651.106.camel@twins>
References: <48A9E97B.6060601@simon.arlott.org.uk>
	 <84144f020808181437n34f3a339j3392ccccfdfd60f9@mail.gmail.com>
	 <48A9ECD2.8030801@simon.arlott.org.uk>
	 <84144f020808181449i546349b9n248b5cf5399e4b0f@mail.gmail.com>
	 <1219315723.8651.106.camel@twins>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 21 Aug 2008 13:51:31 +0300
Message-Id: <1219315891.7813.388.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Tue, 2008-08-19 at 00:49 +0300, Pekka Enberg wrote:
> > Aww, apparently the fglrx driver creates tons of SLAB caches with
> > really funky names for no good reason... Oh well, one more reason to
> > stay away from that crap and help out the nouveau folks instead ;-).

﻿On Thu, 2008-08-21 at 12:48 +0200, Peter Zijlstra wrote:
> fglrx is the AMD/ATI binary evilness - the open source efforts are the
> radeon and radeonhd drivers. AMD/ATI are actually providing
> documentation and paying developers to work on the drivers.

Oh, right. I guess I didn't even consider anyone would still be using
the binary-only ATI crap now that we have proper open source drivers
available.... ;-)

		Pekka

