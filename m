Return-Path: <linux-kernel-owner+w=401wt.eu-S1762245AbYDPRbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762245AbYDPRbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 13:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbYDPRbX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 13:31:23 -0400
Received: from oss.sgi.com ([192.48.170.157]:35203 "EHLO oss.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752948AbYDPRbV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 13:31:21 -0400
Date: Wed, 16 Apr 2008 18:30:48 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
       Ingo Molnar <mingo@elte.hu>, Richard Henderson <rth@twiddle.net>,
       Russell King <rmk@arm.linux.org.uk>, Tony Luck <tony.luck@intel.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Kyle McMartin <kyle@parisc-linux.org>,
       Paul Mackerras <paulus@samba.org>, Paul Mundt <lethal@linux-sh.org>
Subject: Re: [RFC][patch 5/5] mm: Move bootmem descriptors definition to a
	single place
Message-ID: <20080416173048.GB32263@linux-mips.org>
References: <20080416113629.947746497@skyscraper.fehenstaub.lan> <20080416113719.539500813@skyscraper.fehenstaub.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080416113719.539500813@skyscraper.fehenstaub.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 01:36:34PM +0200, Johannes Weiner wrote:

> There are a lot of places that define either a single bootmem
> descriptor or an array of them.  Use only one central array with
> MAX_NUMNODES items instead.
> 
> Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
