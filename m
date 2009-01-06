Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbZAFCwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbZAFCwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbZAFCwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:52:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59808 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbZAFCwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:52:37 -0500
Date: Mon, 5 Jan 2009 18:52:34 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: iwl4965 cannot use "ap auto" on latest 2.6.28/29?
In-Reply-To: <b6a2187b0901042013o2bc295b6r8e7ab92f29528d30@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0901051851460.3057@localhost.localdomain>
References: <b6a2187b0901042013o2bc295b6r8e7ab92f29528d30@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Jan 2009, Jeff Chua wrote:
>
> I'm using latest linux git 2.6.28/29? and it seems the iwl4965 can't
> use "iwconfig ap auto" to associate with the hidden AP. On
> 2.6.28-stable, it's working fine.
> 
> Linus, it is possible for you bump up the SUBLEVEL or EXTRAVERSION to
> differentiate from the 2.6.28-stable version.

Why not just consider it a bug? And -stable adds its own sublevel, so 
differentiating stable from my kernels is always trivial. Hmm?

		Linus
