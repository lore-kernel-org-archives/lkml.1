Return-Path: <linux-kernel-owner+w=401wt.eu-S933381AbXF2PZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933381AbXF2PZa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 11:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760607AbXF2PZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 11:25:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57984 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbXF2PZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 11:25:19 -0400
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
From: David Woodhouse <dwmw2@infradead.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070629150813.GM13886@enneenne.com>
References: <20070627174537.GM13886@enneenne.com>
	 <1182966588.1170.28.camel@pmac.infradead.org>
	 <20070627224623.GO13886@enneenne.com>
	 <1183018133.1170.46.camel@pmac.infradead.org>
	 <20070628081538.GP13886@enneenne.com>
	 <1183019474.1170.66.camel@pmac.infradead.org>
	 <20070628084003.GQ13886@enneenne.com>
	 <1183031060.1170.145.camel@pmac.infradead.org>
	 <20070628161450.GD13886@enneenne.com>
	 <1183117082.1170.308.camel@pmac.infradead.org>
	 <20070629150813.GM13886@enneenne.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 29 Jun 2007 16:25:16 +0100
Message-Id: <1183130716.1170.347.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-06-29 at 17:08 +0200, Rodolfo Giometti wrote:
> On Fri, Jun 29, 2007 at 12:38:02PM +0100, David Woodhouse wrote:
> > 
> > It doesn't apply to the current git tree, which has already had some new
> > system calls added.
> 
> Ok, here the patch against latest git commit.

  CC      fs/fcntl.o
In file included from include/linux/syscalls.h:69,
                 from fs/fcntl.c:8:
include/linux/pps.h:51: error: field ‘tspec’ has incomplete type
make[1]: *** [fs/fcntl.o] Error 1

-- 
dwmw2

