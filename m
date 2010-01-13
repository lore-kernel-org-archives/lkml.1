Return-Path: <linux-kernel-owner+w=401wt.eu-S932109Ab0AMP0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab0AMP0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:26:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622Ab0AMP0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:26:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:50052 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab0AMP0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:26:32 -0500
Date: Wed, 13 Jan 2010 13:26:26 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3] rbtree: Introduce rb_for_each_entry
Message-ID: <20100113152625.GI2934@ghostprotocols.net>
References: <1263387673-15231-1-git-send-email-acme@infradead.org>
 <1263388569.4244.215.camel@laptop>
 <20100113133442.GB5036@nowhere>
 <20100113135205.GC5576@ghostprotocols.net>
 <1263391133.4244.226.camel@laptop>
 <20100113141344.GG2934@ghostprotocols.net>
 <1263392296.4244.228.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263392296.4244.228.camel@laptop>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Jan 13, 2010 at 03:18:16PM +0100, Peter Zijlstra escreveu:
> Sure, but again, that's missing the point, adding that helper isn't a
> good thing. We have no 64bit division operators in Linux either, for the
> very same reason.

Ok, resent without it.

- Arnaldo
