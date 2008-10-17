Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYJQKW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYJQKW1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 06:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754358AbYJQKWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 06:22:09 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:2173 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058AbYJQKWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 06:22:08 -0400
X-Greylist: delayed 542 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 06:22:08 EDT
Date: Fri, 17 Oct 2008 12:13:03 +0200
From: Olivier Galibert <galibert@pobox.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, rdreier@cisco.com,
       Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Fix broken debug output reserve_region_with_split()
Message-ID: <20081017101303.GA9832@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Miller <davem@davemloft.net>, rdreier@cisco.com,
	Geert.Uytterhoeven@sonycom.com, hpa@zytor.com,
	linux-kernel@vger.kernel.org, mingo@elte.hu, yhlu.kernel@gmail.com,
	akpm@linux-foundation.org
References: <adatzbbap8a.fsf@cisco.com> <1224214314.7654.65.camel@pasglop> <alpine.LFD.2.00.0810162036510.3438@nehalem.linux-foundation.org> <20081016.210404.151891223.davem@davemloft.net> <alpine.LFD.2.00.0810162109570.3438@nehalem.linux-foundation.org> <1224220339.7654.84.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1224220339.7654.84.camel@pasglop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 04:12:19PM +1100, Benjamin Herrenschmidt wrote:
> + * - 'R' For a struct resouce pointer, it prints the range of
> + *       addresses (not the name nor the flags)

You missed an 'r' here.

  OG.
