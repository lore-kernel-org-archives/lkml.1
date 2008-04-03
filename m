Return-Path: <linux-kernel-owner+w=401wt.eu-S1758348AbYDCTOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758348AbYDCTOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 15:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755299AbYDCTOF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 15:14:05 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:58635 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbYDCTOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 15:14:04 -0400
Date: Thu, 3 Apr 2008 21:13:50 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Hugh Dickins <hugh@veritas.com>
cc: Johannes Weiner <hannes@saeurebad.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, mingo@elte.hu, davem@davemloft.net,
       hskinnemoen@atmel.com, cooloney@kernel.org, starvik@axis.com,
       dhowells@redhat.com, ysato@users.sourceforge.net, takata@linux-m32r.org,
       ralf@linux-mips.org, kyle@parisc-linux.org, paulus@samba.org,
       schwidefsky@de.ibm.com, lethal@linux-sh.org, jdike@addtoit.com,
       miles@gnu.org, chris@zankel.net, rmk@arm.linux.org.uk,
       tony.luck@intel.com, akpm@linux-foundation.org
Subject: Re: [RFC 10/22] m68k: Use generic show_mem()
In-Reply-To: <Pine.LNX.4.64.0804031705230.11465@blonde.site>
Message-ID: <Pine.LNX.4.64.0804032113100.22696@anakin>
References: <12071688283927-git-send-email-hannes@saeurebad.de>
 <1207168941186-git-send-email-hannes@saeurebad.de> <Pine.LNX.4.64.0804030939320.9848@anakin>
 <87myobp02g.fsf@saeurebad.de> <Pine.LNX.4.64.0804031538150.11898@anakin>
 <87wsnfnfdu.fsf@saeurebad.de> <Pine.LNX.4.64.0804031705230.11465@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Apr 2008, Hugh Dickins wrote:
> On Thu, 3 Apr 2008, Johannes Weiner wrote:
> > Sorry for the wasted time.  These cleanups already took more energy than
> > they are worth it, I guess... :/
> 
> Please do persist, I for one appreciate your efforts on this:
> something I wanted to do years ago but never yet got around to.

Ack. Don't be disappointed by our comments!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
