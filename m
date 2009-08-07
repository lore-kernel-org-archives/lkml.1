Return-Path: <linux-kernel-owner+w=401wt.eu-S1757915AbZHGO0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757915AbZHGO0Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 10:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757906AbZHGO0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 10:26:16 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60356 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757905AbZHGO0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 10:26:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <s5hy6pvygh4.wl%tiwai@suse.de>
References: <s5hy6pvygh4.wl%tiwai@suse.de> <s5hvdmos4i8.wl%tiwai@suse.de> <alpine.DEB.2.01.0906211926080.6439@bogon> <6950.1245661098@redhat.com> <3776.1249406624@redhat.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: dhowells@redhat.com, peterz@infradead.org,
       Linux filesystem caching discussion list 
	<linux-cachefs@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-cachefs] CacheFiles: Readpage failed on backing file
Date: Fri, 07 Aug 2009 15:26:04 +0100
Message-ID: <14978.1249655164@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takashi Iwai <tiwai@suse.de> wrote:

> OK, I've been running the patched kernel for a day, and it seems working
> fine.  FWIW, I applied your previous fix
>     CacheFiles: Handle truncate unlocking the page we're reading
> as well.
> 
> Tested-by: Takashi Iwai <tiwai@suse.de>

Thanks!

David
