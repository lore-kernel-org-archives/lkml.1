Return-Path: <linux-kernel-owner+w=401wt.eu-S1752403AbXCULZT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752403AbXCULZT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:25:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752388AbXCULZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:25:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59603 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbXCULZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:25:17 -0400
Subject: Re: 2.6.21-rc4-mm1
From: David Woodhouse <dwmw2@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@outflux.net>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20070320214714.0e584cd4.akpm@linux-foundation.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
	 <20070320103151.f65c81b6.randy.dunlap@oracle.com>
	 <20070320192016.GC22797@outflux.net>
	 <20070320214714.0e584cd4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 21 Mar 2007 11:25:03 +0000
Message-Id: <1174476303.20505.52.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-20 at 21:47 -0800, Andrew Morton wrote:
> On Tue, 20 Mar 2007 12:20:16 -0700 Kees Cook <kees@outflux.net> wrote:
> 
> > I can't 
> > get 2.6.21-rc4-mm1 to compile (with or without this fix):
> > 
> >   GEN     .version
> > init/.missing_syscalls.h.cmd:2: *** missing separator.  Stop.
> > make: *** [.tmp_vmlinux1] Error 2

What if you remove init/.missing_syscalls.h.cmd _and_ apply the patch,
then try again?

-- 
dwmw2

