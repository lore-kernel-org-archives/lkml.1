Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbYHFW3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbYHFW3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 18:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369AbYHFW3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 18:29:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbYHFW3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 18:29:02 -0400
Date: Wed, 6 Aug 2008 18:28:21 -0400
From: Alan Cox <alan@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@redhat.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] m68k/amiserial: fix fallout of tty break handling rework
Message-ID: <20080806222821.GB30535@devserv.devel.redhat.com>
References: <Pine.LNX.4.64.0808062218490.17614@anakin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0808062218490.17614@anakin>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 10:19:39PM +0200, Geert Uytterhoeven wrote:
> commit 9e98966c7bb94355689478bc84cc3e0c190f977e (tty: rework break handling)
> forgot to update one exit point of rs_break() in the Amiga serial driver.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Alan Cox <alan@redhat.com>
