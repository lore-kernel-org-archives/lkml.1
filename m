Return-Path: <linux-kernel-owner+w=401wt.eu-S933644AbXGKWsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbXGKWsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 18:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757855AbXGKWsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 18:48:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38230 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757369AbXGKWsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 18:48:37 -0400
Date: Wed, 11 Jul 2007 15:48:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Add /sys/kernel/notes
In-Reply-To: <20070711224207.48F464D0555@magilla.localdomain>
Message-ID: <alpine.LFD.0.999.0707111547270.20061@woody.linux-foundation.org>
References: <20070711224207.48F464D0555@magilla.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 11 Jul 2007, Roland McGrath wrote:
> 
> > If it's basically just a set of hashes, I won't worry.
> 
> It's just one hash.  (Each .ko has one too, but I didn't bother with the
> /sys/module/name/notes hack because it was too much trouble.)

Ok, then I withdraw any objection. The only way that will give you any 
more information is if you already have practically the information to 
begin with, and you can just choose a particular case from a limited set 
of other cases.

No worries then,

		Linus
