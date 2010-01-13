Return-Path: <linux-kernel-owner+w=401wt.eu-S1755286Ab0AMNrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0AMNrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:47:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755214Ab0AMNra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:47:30 -0500
Received: from casper.infradead.org ([85.118.1.10]:40888 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175Ab0AMNr3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:47:29 -0500
Date: Wed, 13 Jan 2010 11:47:13 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Kirill Smelkov <kirr@landau.phys.spbu.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/6] perf top: fix code typo in prompt_symbol()
Message-ID: <20100113134712.GF2934@ghostprotocols.net>
References: <cover.1262952612.git.kirr@landau.phys.spbu.ru>
 <b589503ffe4678bbaab941771c03e123a33c180a.1262952612.git.kirr@landau.phys.spbu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b589503ffe4678bbaab941771c03e123a33c180a.1262952612.git.kirr@landau.phys.spbu.ru>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Jan 08, 2010 at 03:23:06PM +0300, Kirill Smelkov escreveu:
> sym_filter is what was (if ever) passed with -s option. What was typed by
> user, and what we were looking for, is in buf.
> 
> Signed-off-by: Kirill Smelkov <kirr@landau.phys.spbu.ru>
> ---
>  tools/perf/builtin-top.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Thanks, applied.

- Arnaldo
