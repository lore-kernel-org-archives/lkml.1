Return-Path: <linux-kernel-owner+w=401wt.eu-S1754428AbZJZNEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbZJZNEa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 09:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbZJZNE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 09:04:29 -0400
Received: from khc.piap.pl ([195.187.100.11]:36773 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754376AbZJZNE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 09:04:29 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-next@vger.kernel.org,
       "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>, Stephen Smalley <sds@tycho.nsa.gov>,
       Eric Paris <eparis@parisplace.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: writable limits to -next
References: <4AC6339B.7000905@gmail.com>
	<20091006225751.7d5f3eec.sfr@canb.auug.org.au>
	<4AE16B0A.7020400@gmail.com>
	<20091026094741.5a1d492c.sfr@canb.auug.org.au>
	<m3eiorc7r4.fsf@intrepid.localdomain>
	<20091026120457.39f7ab83.sfr@canb.auug.org.au>
Date: Mon, 26 Oct 2009 14:04:30 +0100
In-Reply-To: <20091026120457.39f7ab83.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Mon, 26 Oct 2009 12:04:57 +1100")
Message-ID: <m3r5sqmhlt.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

>> It's not ok to submit under e.g. GPL v3 only, I'd suggest "under GPL v2
>> and optionally other licence(s)" or something like that.
>
> Or maybe "under a license compatible with the Linux kernel source".

Right, it looks better. Now I think the author doesn't even have to
licence under GPLv2, e.g. BSD alone will do as well.
-- 
Krzysztof Halasa
