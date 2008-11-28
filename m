Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbYK1JBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbYK1JBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 04:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752660AbYK1JBE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 04:01:04 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46367
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbYK1JBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 04:01:01 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Pavel Machek <pavel@suse.cz>
Subject: Re: Document hadling of bad memory
Date: Fri, 28 Nov 2008 03:00:26 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>,
       Trivial patch monkey <trivial@kernel.org>
References: <20081126161521.GC1983@elf.ucw.cz>
In-Reply-To: <20081126161521.GC1983@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811280300.26969.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 November 2008 10:15:21 Pavel Machek wrote:
> Document how to deal with bad memory reported with memtest.
...
> +BadRAM
> +######
> +BadRAM is the actively developed and available as kernel-patch
> +here:  http://rick.vanrein.org/linux/badram/

So the patch isn't worth merging, but documentation about the out-of-tree 
patch is worth merging?

I'm not objecting, I'm just confused about to what the merge criteria are...

Rob
