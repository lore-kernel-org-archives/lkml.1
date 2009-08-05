Return-Path: <linux-kernel-owner+w=401wt.eu-S934245AbZHEMlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245AbZHEMlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 08:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933169AbZHEMlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 08:41:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60230 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933132AbZHEMlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 08:41:49 -0400
Date: Wed, 5 Aug 2009 09:41:33 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf report: Make --sort comm,dso,symbol the default
Message-ID: <20090805124133.GB10688@ghostprotocols.net>
References: <1249467921-10450-1-git-send-email-penberg@cs.helsinki.fi> <1249468878.7924.251.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249468878.7924.251.camel@twins>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Aug 05, 2009 at 12:41:18PM +0200, Peter Zijlstra escreveu:
> On Wed, 2009-08-05 at 13:25 +0300, Pekka Enberg wrote:
> > If you're doing performance testing, you're interested in the symbols
> > anyway so lets make "--sort comm,dso,symbol" the default sort option.
> 
> Seems sensible,
> 
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
